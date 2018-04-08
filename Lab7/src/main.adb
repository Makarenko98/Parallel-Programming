with Ada.Text_IO; use Ada.Text_IO;
with Data;
with Ada.Integer_Text_IO;
with Ada.Synchronous_Task_Control;
use Ada.Integer_Text_IO;
use Ada.Synchronous_Task_Control;

--  e = (A*(MA*ME)*SORT(B))

procedure Main is
   package data1 is new data(2);
   use data1;
   N: Integer := 2;

   MA: Matrix;
   ME: Matrix;
   A: Vector;
   B: Vector;
   E:Integer;

begin
   Put_Line("started");

   MA := getMatrixOfOne;
   ME := getMatrixOfOne;
   A := getVectorOfOne;
   B := getVectorOfOne;

   E := F1(MA, Me, A, B);

   Put_Line("Result:");
   Put(E);

end Main;
