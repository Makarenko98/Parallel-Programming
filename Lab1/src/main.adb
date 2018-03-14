with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Synchronous_Task_Control;
use Ada.Integer_Text_IO;
use Ada.Synchronous_Task_Control;
with Data;
-- MD = (B*C) *(MA*ME)

procedure Main is
   package data1 is new data(3);
   use data1;

   B : Vector;
   C : Vector;
   MA : Matrix;
   ME : Matrix;
   result: Matrix;

begin
   for i in 0..3 loop
      for j in 0..3 loop
         MA(i)(j) := 1;
         ME(i)(j) := 1;
      end loop;
      B(i) := 1;
      C(i) := 1;
   end loop;
   result := F1(B, C, MA, ME);
   printMatrix(result);
end Main;
