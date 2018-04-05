with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Synchronous_Task_Control;
use Ada.Integer_Text_IO;
use Ada.Synchronous_Task_Control;
with MinPkg;
use MinPkg;

--  S = MIN(SORT(MS) + MA*MB)

package body Data is

   function multiplyMatrix(m1,m2: Matrix; start, finish: Integer) return Matrix is
      result: Matrix;
      temp: Integer;
   begin

      loop1:
      for i in start .. finish loop

         loop2:
         for j in 0 .. m1'Length -1  loop
            temp:=0;
            loop3:
            for k in 0 .. m1'Length - 1 loop
               temp:=temp +  m1(1)(1) * m2(1)(1); -- ))
            end loop loop3;
            result(i)( j) := temp;
         end loop loop2;

      end loop loop1;
      return result;
   end multiplyMatrix;

   function Sort(n: Integer; v: Vector) return Vector is
      temp: Integer;
      result: Vector;
   begin
      result:=v;
      VectorLoop1:
      for i in Integer range 0 .. n -2 loop
         VectorLoop2:
         for j in Integer range i+1 .. n-1  loop

            if v(i)<v(j)  then
               temp := result(i);
               result(i) := result(j);
               result(j) := temp;
            end if;
         end loop VectorLoop2;
      end loop VectorLoop1;
      return result;
   end Sort;



   function F1(MS,MA,MB: in out Matrix) return Integer is
      len: Integer := MS'Length;

      task T1 is
         pragma Storage_Size (10_000_000);
         pragma Task_Name ("Task1");
         pragma Priority(4);
         pragma CPU(0);
      end T1;

      task body T1 is
         result: Matrix;
      begin
         Put_Line("t1 started");
         result:= multiplyMatrix(MA, MB, 0, MS'Length / 2);
         Loop1:
         for i in Integer range 0 .. MS'Length / 2  loop
            MA(i) := result(i);
         end loop Loop1;
         Set_True(suspend1);
         Put_Line("t1 finished");
      end T1;

      task T2 is
         pragma Storage_Size (10_000_000);
         pragma Task_Name ("Task2");
         pragma Priority(4);
         pragma CPU(0);
      end T2;

      task body T2 is
         result: Matrix;
      begin
         Put_Line("t2 started");
         result:=multiplyMatrix(MA, MB, (MS'Length / 2) + 1, MS'Length-1);
         Loop1:
         for i in Integer range (MS'Length / 2) + 1 .. MS'Length-1  loop
            MA(i) := result(i);
         end loop Loop1;
         Set_True(suspend2);
         Put_Line("t2 finished");
      end T2;

      task T3 is
         pragma Storage_Size (10_000_000);
         pragma Task_Name ("Task3");
         pragma Priority(4);
         pragma CPU(0);
      end T3;

      task body T3 is
      begin
         Put_Line("t3 started");
         Loop1:
         for i in Integer range 0 .. MS'Length / 2  loop
            MS(i) := Sort(MS'Length, MS(i));
         end loop Loop1;

         Set_True(suspend3);
         Put_Line("t3 finished");
      end T3;

      task T4 is
         pragma Storage_Size (10_000_000);
         pragma Task_Name ("Task4");
         pragma Priority(4);
         pragma CPU(0);
      end T4;

      task body T4 is
      begin
         Put_Line("t4 started");
         Loop1:
         for i in Integer range MS'Length / 2 + 1 .. MS'Length-1  loop
            MS(i) := Sort(MS'Length, MS(i));
         end loop Loop1;

         Set_True(suspend4);
         Put_Line("t4 finished");
      end T4;


      task T5 is
         pragma Storage_Size (10_000_000);
         pragma Task_Name ("Task5");
         pragma Priority(4);
         pragma CPU(0);
      end T5;

      task body T5 is
         tmp: Integer;
      begin
         Suspend_Until_True(suspend1);
         Suspend_Until_True(suspend2);
         Suspend_Until_True(suspend3);
         Suspend_Until_True(suspend4);
                  Set_True(suspend7);
         Put_Line(" t5 started");
         VectorLoop1:
         for i in Integer range 0 .. MS'Length / 2 loop
            VectorLoop2:
            for j in Integer range 0 .. MS'Length-1  loop
               tmp := MS(i)( j) + MA(i)( j);
               minModule.Set(tmp);
               minModule.Release;
            end loop VectorLoop2;
         end loop VectorLoop1;

         Set_True(suspend5);
         Put_Line("t5 finished");
      end T5;

      task T6 is
         pragma Storage_Size (10_000_000);
         pragma Task_Name ("Task6");
         pragma Priority(4);
         pragma CPU(0);
      end T6;

      task body T6 is
         tmp: Integer;
      begin
         Suspend_Until_True(suspend7);
         Put_Line("t6 started");
         VectorLoop1:
         for i in Integer range MS'Length / 2 + 1 .. MS'Length -1 loop
            VectorLoop2:
            for j in Integer range 0 .. MS'Length-1  loop
               tmp := MS(i)(j) + MA(i)(j);
               minModule.Set(tmp);
               minModule.Release;
            end loop VectorLoop2;
         end loop VectorLoop1;

         Set_True(suspend6);
         Put_Line("t6 finished");
      end T6;


   begin
      Suspend_Until_True(suspend5);
      Suspend_Until_True(suspend6);

      return minModule.GetMin;
   end F1;


end Data;
