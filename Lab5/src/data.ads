with Ada.Synchronous_Task_Control;
use Ada.Synchronous_Task_Control;
with MinPkg;
use MinPkg;


generic
   n: Integer;
package Data is

   type Vector is array(0..n) of Integer;
   type Matrix is array(0..n) of Vector;
   suspend1: Suspension_Object;
   suspend2: Suspension_Object;
   suspend3: Suspension_Object;
   suspend4: Suspension_Object;
   suspend5: Suspension_Object;
   suspend6: Suspension_Object;
      suspend7: Suspension_Object;

   minModule: MinPkg.Min;

   function F1(MS,MA,MB:in out  Matrix) return Integer;

end Data;
