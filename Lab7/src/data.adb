with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Synchronous_Task_Control;
use Ada.Integer_Text_IO;
use Ada.Synchronous_Task_Control;

--  e = (A*(MA*ME)*SORT(B))

package body Data is

   function multiplyMatrix(m1,m2: Matrix; start, finish: Integer) return Matrix is
      result: Matrix;
      temp: Integer;
   begin
      result := getMatrixOfZero;
      loop1:
      for i in start .. finish loop

         loop2:
         for j in 0 .. m1'Length - 1  loop
            temp:=0;
            loop3:
            for k in 0 .. m1'Length - 1 loop
               temp:=temp + m1(i)(k) * m2(k)(j);
            end loop loop3;
            result(i)(j) := temp;
         end loop loop2;
      end loop loop1;
      return result;
   end multiplyMatrix;

   function SortPart(n: Integer; v: Vector; start, finish: Integer) return Vector is
      temp: Integer;
      result: Vector;
   begin
      result:=v;
      VectorLoop1:
      for i in Integer range start .. finish-2 loop
         VectorLoop2:
         for j in Integer range i+1 .. finish-1  loop

            if v(i)<v(j)  then
               temp := result(i);
               result(i) := result(j);
               result(j) := temp;
            end if;
         end loop VectorLoop2;
      end loop VectorLoop1;
      return result;
   end SortPart;

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

   function sumVectors(v1,v2: Vector) return Vector is
      result: Vector;
   begin
      loop1:
      for i in v1'Range loop
         result(i):=v1(i) + v2(i);
      end loop loop1;
      return result;
   end sumVectors;

   function sumMatrix(m1,m2: Matrix) return Matrix is
      result: Matrix;
   begin
      loop1:
      for i in m1'Range loop
         result(i) := sumVectors(m1(i), m2(i));
      end loop loop1;
      return result;
   end sumMatrix;

   function getVectorOfZero return Vector is
      result: Vector;
   begin
      for i in 0..N loop
         result(i) := 0;
      end loop;
      return result;
   end getVectorOfZero;

   function getMatrixOfZero return Matrix is
      result: Matrix;
   begin
      for i in 0..N loop
         result(i) := getVectorOfZero;
      end loop;
      return result;
   end getMatrixOfZero;

   function getVectorOfOne return Vector is
      result: Vector;
   begin
      for i in 0..N loop
         result(i) := 1;
      end loop;
      return result;
   end getVectorOfOne;

   function getMatrixOfOne return Matrix is
      result: Matrix;
   begin
      for i in 0..N loop
         result(i) := getVectorOfOne;
      end loop;
      return result;
   end getMatrixOfOne;

   function vectorToMatrixVertical(v: Vector) return Matrix is
      result: Matrix;
   begin
      result := getMatrixOfZero;
      for i in 0..N loop
         result(i)(0) := v(0);
      end loop;
      return result;
   end vectorToMatrixVertical;

   function vectorToMatrixHorizontal(v: Vector) return Matrix is
      result: Matrix;
   begin
      result := getMatrixOfZero;
      result(0) := v;
      return result;
   end vectorToMatrixHorizontal;

   function matrixToVectorVertical(m : Matrix) return Vector is
      result: Vector;
   begin
      for i in 0..N loop
         result(i) := m(i)(0);
      end loop;
      return result;
   end matrixToVectorVertical;

   function matrixToVectorHorizontal(m : Matrix) return Vector is
   begin
      return m(0);
   end matrixToVectorHorizontal;



   --  e = (A*(MA*ME)*SORT(B))
   function F1(MA,ME: in out Matrix; A, B :in out Vector) return Integer is
      res: Integer;
      task T1 is
         entry mult (m: in out Matrix);
         entry mult1(m: in out Matrix);
         entry mult2(m: in out Matrix);
         entry mult3(m: in out Matrix);
         entry mult4(m: in out Matrix);
         entry mult5(m: in out Matrix);
         entry sorted(v: Vector);
         pragma Storage_Size (10_000_000);
         pragma Task_Name ("Task1");
         pragma Priority(4);
         pragma CPU(0);
      end T1;

      task body T1 is
         result: Matrix;
         vS: Vector;
      begin
         Put_Line("t1 started");

         result:= multiplyMatrix(MA, ME, 0, MA'Length / 4 -1);

         accept mult(m: in out Matrix) do
            result:=sumMatrix(result, m);
         end mult;

         accept mult1 (m : in out Matrix) do
            result:=sumMatrix(result, m);
            m:= result;
         end mult1;

         result:= multiplyMatrix(vectorToMatrixHorizontal(A),
                                 result, 0, MA'Length/4 -1 );

         accept mult2(m: in out Matrix) do
            result:= sumMatrix(result, m);
         end mult2;

         accept mult3 (m : in out Matrix) do
            result:= sumMatrix(result, m);
            m:= result;
         end mult3;

         accept sorted (v : Vector) do
            vS:=v;
         end sorted;
         result:= multiplyMatrix(result,
                                 vectorToMatrixVertical(vS),
                                 0, MA'Length / 4 - 1);

         accept mult4(m: in out Matrix) do
            result:=sumMatrix(result, m);
         end mult4;

         accept mult5 (m : in out Matrix) do
            result:=sumMatrix(result, m);
            m:= result;
         end mult5;

         res := result(0)(0);
         Set_True(suspend1);

         Put_Line("t1 finished");
      end T1;

      task T2 is
         entry mult (m: in out Matrix);
         entry mult2(m: in out Matrix);
         entry mult4(m: in out Matrix);
         entry sorted(v: Vector);
         pragma Storage_Size (10_000_000);
         pragma Task_Name ("Task2");
         pragma Priority(4);
         pragma CPU(0);
      end T2;

      task body T2 is
         result: Matrix;
         vS: Vector;
      begin
         Put_Line("t2 started");
         result:=multiplyMatrix(MA, ME, (MA'Length / 4),  (MA'Length / 2)-1);

         accept mult(m: in out Matrix) do
            result:=sumMatrix(result, m);
            T1.mult1(result);
            m := result;
         end mult;

         result:=multiplyMatrix(vectorToMatrixHorizontal(A), result,
                                (MA'Length / 4),  (MA'Length / 2)-1);

         accept mult2(m: in out Matrix) do
            result:=sumMatrix(result, m);
            T1.mult3(result);
            m := result;
         end mult2;

         accept sorted (v : Vector) do
            vS:=v;
         end sorted;
         result:= multiplyMatrix(result,
                                 vectorToMatrixVertical(vS),
                                 (MA'Length / 4),  (MA'Length / 2)-1);

         accept mult4(m: in out Matrix) do
            result:=sumMatrix(result, m);
            T1.mult5(result);
            m := result;
         end mult4;

         Put_Line("t2 finisheded");
      end T2;

      task T3 is
         entry sorted(v: Vector);
         pragma Storage_Size (10_000_000);
         pragma Task_Name ("Task3");
         pragma Priority(4);
         pragma CPU(0);
      end T3;

      task body T3 is
         result: Matrix;
         vS: Vector;
      begin
         Put_Line("t3 started");
         result:=multiplyMatrix(MA, ME, (MA'Length / 2), (3*MA'Length / 4)-1);

         T1.mult(result);

         result:=multiplyMatrix(vectorToMatrixHorizontal(A), result,
                                (MA'Length / 2), (3*MA'Length / 4)-1);
         T1.mult2(result);

         accept sorted (v : Vector) do
            vS:=v;
         end sorted;
         result:= multiplyMatrix(result,
                                 vectorToMatrixVertical(vS),
                                 (MA'Length / 2), (3*MA'Length / 4)-1);

         Put_Line("t3 finished");
         T1.mult4(result);

      end T3;

      task T4 is
         entry sorted(v: Vector);
         pragma Storage_Size (10_000_000);
         pragma Task_Name ("Task4");
         pragma Priority(4);
         pragma CPU(0);
      end T4;

      task body T4 is
         result: Matrix;
         vS: Vector;
      begin
         Put_Line("t4 started");
         result:=multiplyMatrix(MA, ME, (3*MA'Length / 4), MA'Length-1);

         T2.mult(result);

         result:=multiplyMatrix(vectorToMatrixHorizontal(A), result,
                                (3*MA'Length / 4), MA'Length-1);
         T2.mult2(result);

         accept sorted (v : Vector) do
            vS:=v;
         end sorted;
         result:= multiplyMatrix(result,
                                 vectorToMatrixVertical(vS),
                                 (3*MA'Length / 4), MA'Length-1);
         Put_Line("t4 finished");
         T2.mult4(result);
      end T4;


      task T5 is
         entry merge (v: Vector);
         pragma Storage_Size (10_000_000);
         pragma Task_Name ("Task5");
         pragma Priority(4);
         pragma CPU(0);
      end T5;

      task body T5 is
         v1, result: Vector;
         v1c, v2c: Integer;
      begin
         Put_Line("t5 started");
         v1c:=0;
         v2c:=0;
         v1:= SortPart(B'length, B, 0, B'length/2 -1);

         accept merge (v : in Vector) do

            for i in 0..N-1 loop
               if v1(v1c) < v(v2c) then
                  result(i) := v1(v1c);
                  v1c := v1c + 1;
               else
                  result(i) := v(v2c);
                  v2c := v2c + 1;
               end if;
            end loop;

         end merge;

         Put_Line("t5 finished");
         T1.sorted(result);
         T2.sorted(result);
         T3.sorted(result);
         T4.sorted(result);
      end T5;

      task T6 is
         pragma Storage_Size (10_000_000);
         pragma Task_Name ("Task6");
         pragma Priority(4);
         pragma CPU(0);
      end T6;

      task body T6 is
         result: Vector;
      begin
         Put_Line("t6 started");

         result:= SortPart(B'length, B, B'length/2 , B'length - 1);

         Put_Line("t6 finished");
         T5.merge(result);
      end T6;


   begin
      Suspend_Until_True(suspend1);
      return res;
   end F1;


end Data;
