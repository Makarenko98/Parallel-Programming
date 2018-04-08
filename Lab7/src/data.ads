with Ada.Synchronous_Task_Control;
use Ada.Synchronous_Task_Control;

generic
   n: Integer;
package Data is

   type Vector is array(0..n) of Integer;
   type Matrix is array(0..n) of Vector;
   suspend1: Suspension_Object;


   function F1(MA,ME: in out Matrix; A, B :in out Vector) return Integer;
   function getVectorOfZero return Vector;
   function getMatrixOfZero return Matrix;
   function getVectorOfOne return Vector;
   function getMatrixOfOne return Matrix;
   procedure printVector(v:Vector);
   procedure printMatrix(m:Matrix);

end Data;
