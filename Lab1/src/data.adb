with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Synchronous_Task_Control;
use Ada.Integer_Text_IO;
use Ada.Synchronous_Task_Control;

-- MD = (B*C) *(MA*ME)

package body Data is

   function dotProduct(v1,v2:Vector) return Integer is
      result: Integer;
   begin
      result:=0;
      loop1:
      for i in v1'Range loop
         result := result + v1(i)*v2(i);
      end loop loop1;
      return result;
   end dotProduct;

   function multVectorNumber(a: Integer; v: Vector) return Vector is
      result:Vector;
   begin
      loop1:
      for i in v'Range loop
         result(i) := v(i)*a;
      end loop loop1;
      return result;
   end multVectorNumber;

   function multMatrixNumber(a: Integer; m: Matrix) return Matrix is
      result:Matrix;
   begin
      matrixLoop1:
      for i in m'Range loop
         result(i) := multVectorNumber(a, m(i));
      end loop matrixLoop1;
      return result;
   end multMatrixNumber;

   function multiplyMatrix(m1,m2: Matrix) return Matrix is
      result: Matrix;
      temp: Integer;
   begin

      for i in m1'Range loop
        for j in m1'Range loop
          temp := 0;
            for r in m1'Range loop
              temp := temp + m1(i)(r) * m2(r)(j);
            end loop;
          result(i) (j) := temp;
        end loop;
      end loop;

      return result;
   end multiplyMatrix;

   procedure printVector(v:Vector) is
   begin
      VectorLoop:
      for i in v'Range loop
         Put(Integer'Image(v(i)) & " ");
      end loop VectorLoop;
      Put_Line("");
   end printVector;

   procedure printMatrix(m:Matrix) is
   begin
      VectorLoop:
      for i in m'Range loop
         printVector(m(i));
      end loop VectorLoop;
   end printMatrix;




   function F1 (B, C : Vector; MA, ME : Matrix) return Matrix is
      result : Matrix;
      BxC : Integer;
      MAxME : Matrix;

   task T1 is
     pragma Storage_Size (10_000_000);
     pragma Task_Name ("Task1");
     pragma Priority(4);
     pragma CPU(0);
   end T1;

   task body T1 is

   begin
      Put_Line("Calculation B*C started");

      BxC := dotProduct(B, C);

      Set_True(suspend1);
      Put_Line("Calculation B*C finished");
   end T1;

   task T2 is
     pragma Storage_Size (10_000_000);
     pragma Task_Name ("Task2");
     pragma Priority(4);
     pragma CPU(0);
   end T2;

   task body T2 is
   begin
      Put_Line("Calculation MA*ME started");

      MAxME := multiplyMatrix(MA, ME);
      Set_True(suspend2);
      Put_Line("Calculation MA*ME finished");
   end T2;

   begin
      Suspend_Until_True(suspend1);
      Suspend_Until_True(suspend2);
      result := multMatrixNumber(BxC, MAxME);
      return result;
   end F1;

end Data;
