using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab3
{
    class Data
    {
        public int N { get; private set; }

        static object locker = new object();

        public Data(int n)
        {
            N = n;
        }

        // ME = (A* SORT(C))*(MA* ME+MD)
        public Matrix Func1()
        {
            var A = Vector.GetRandomVector(N);
            var C = Vector.GetRandomVector(N);
            var MA = Matrix.GetRandomMatrix(N);
            var ME = Matrix.GetRandomMatrix(N);
            var MD = Matrix.GetRandomMatrix(N);

            return (MA * ME + MD) * (A * C.Sort());
        }

        // MF = k* MG - h* MK*ML
        public Matrix Func2()
        {
            int k = 3;
            int h = 2;
            var MG = Matrix.GetRandomMatrix(N);
            var MK = Matrix.GetRandomMatrix(N);
            var ML = Matrix.GetRandomMatrix(N);

            return MG * k - MK * ML * h;
        }

        // O = (P+R)*(MS*MT)
        public Vector Func3()
        {
            var P = Vector.GetRandomVector(N);
            var R = Vector.GetRandomVector(N);
            var MS = Matrix.GetRandomMatrix(N);
            var MT = Matrix.GetRandomMatrix(N);

            var tempM = new Matrix(N);
            tempM[0] = P + R;

            return (tempM * (MS * MT))[0];
        }

        public static void Print(object o)
        {
            lock (locker)
            {
                Console.WriteLine(o);
            }
        }
    }
}
