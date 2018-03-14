using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab3
{
    class Matrix
    {
        public int Length { get; private set; }
        Vector[] arr;

        public Matrix (int length)
        {
            Length = length;
            arr = new Vector[Length];
            for (int i = 0; i < Length; i++)
                arr[i] = new Vector (Length);
        }

        public Vector this [int index]
        {
            get
            {
                if (index >= Length || index < 0)
                    throw new IndexOutOfRangeException ();
                else
                    return arr[index];
            }

            set
            {
                if (index >= Length || index < 0)
                    throw new IndexOutOfRangeException ();
                else
                    arr[index] = value;
            }
        }

        public static Matrix GetMatrixOfZero (int N)
        {
            Vector[] vectors = new Vector[N];
            for (int i = 0; i < N; i++)
                vectors[i] = Vector.GetVectorOfZero (N);
            return new Matrix (N) { arr = vectors };
        }

        public static Matrix GetMatrixOfOne (int N)
        {
            Vector[] vectors = new Vector[N];
            for (int i = 0; i < N; i++)
                vectors[i] = Vector.GetVectorOfOne (N);
            return new Matrix (N) { arr = vectors };
        }

        public static Matrix GetRandomMatrix (int N)
        {
            Vector[] vectors = new Vector[N];
            for (int i = 0; i < N; i++)
                vectors[i] = Vector.GetRandomVector (N);
            return new Matrix (N) { arr = vectors };
        }

        public Matrix TransMatrix ()
        {
            int tmp;
            for (int i = 0; i < Length; i++)
            {
                for (int j = 0; j < Length; j++)
                {
                    tmp = arr[i][j];
                    arr[i][j] = arr[j][i];
                    arr[j][i] = tmp;
                }
            }
            return this;
        }

        public static Matrix operator * (Matrix m1, Matrix m2)
        {
            if (m1.Length != m2.Length)
                throw new ArgumentException ();
            int n = m1.Length;
            Matrix result = new Matrix (n);
            for (int i = 0; i < n; i++)
                result[i] = new Vector (n);
            for (int k = 0; k < n; k++)
            {
                for (var i = 0; i < n; i++)
                {
                    int t = 0;
                    for (int j = 0; j < n; j++)
                        t += m1[i][j] * m2[j][k];
                    result[i][k] = t;
                }
            }
            return result;
        }

        public static Matrix operator * (Matrix m1, int n)
        {
            Matrix result = new Matrix (m1.Length);
            for (int i = 0; i < m1.Length; i++)
                result[i] = m1[i] * n;
            return result;
        }

        public static Matrix operator + (Matrix m1, Matrix m2)
        {
            if (m1.Length != m2.Length)
                throw new ArgumentException ();
            Matrix result = new Matrix (m1.Length);
            for (int i = 0; i < m1.Length; i++)
                result[i] = m1[i] + m2[i];
            return result;
        }

        public static Matrix operator - (Matrix m1, Matrix m2)
        {
            if (m1.Length != m2.Length)
                throw new ArgumentException ();
            Matrix result = new Matrix (m1.Length);
            for (int i = 0; i < m1.Length; i++)
                result[i] = m1[i] - m2[i];
            return result;
        }

        public override string ToString ()
        {
            string result = "";
            for (int i = 0; i < Length; i++)
                result += arr[i] + "\n";
            return result;
        }
    }
}