with Ada.Text_IO; use Ada.Text_IO;
with Data;
with Ada.Integer_Text_IO;
with Ada.Synchronous_Task_Control;
use Ada.Integer_Text_IO;
use Ada.Synchronous_Task_Control;

--  S = MIN(SORT(MS) + MA*MB)

procedure Main is
   package data1 is new data(2);
   use data1;
   N: Integer := 2;
   S: Integer;

   MS: Matrix;
   MA: Matrix;
   MB: Matrix;

begin
   Put_Line("started");

   for i in 0..N loop
      for j in 0..N loop
         MS(i)( j) := 1;
         MA(i)( j) := 1;
         MB(i)( j) := 1;
      end loop;
   end loop;

   S := F1(MS, MA, MB);

   Put_Line("Result:");
   Put(S);

end Main;
