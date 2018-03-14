with Ada.Synchronous_Task_Control;
use Ada.Synchronous_Task_Control;

generic
   n: Integer;
package Data is
   suspend1: Suspension_Object;
   suspend2: Suspension_Object;

   type Vector is array(0..n) of Integer;
   type Matrix is array(0..n) of Vector;

   function F1 (B, C : Vector; MA, ME : Matrix) return Matrix;

   procedure printMatrix(m: Matrix);
   procedure printVector(v: Vector);
end Data;
