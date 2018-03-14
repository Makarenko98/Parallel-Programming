using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab3
{
    class Vector
    {
        public int Length { get; private set; }
        int[] arr;

        static Random _random = new Random ();
        static int _min = 0;
        static int _max = 10;

        public Vector (int length)
        {
            Length = length;
            arr = new int[Length];
        }

        public int this [int index]
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

        public static Vector GetVectorOfZero (int N)
        {
            int[] vector = new int[N];
            for (int i = 0; i < N; i++)
                vector[i] = 0;
            return new Vector (N) { arr = vector };
        }

        public static Vector GetVectorOfOne (int N)
        {
            int[] vector = new int[N];
            for (int i = 0; i < N; i++)
                vector[i] = 1;
            return new Vector (N) { arr = vector };
        }

        public static Vector GetRandomVector (int N)
        {
            int[] vector = new int[N];
            for (int i = 0; i < N; i++)
                vector[i] = _random.Next (_min, _max);
            return new Vector (N) { arr = vector };
        }

        public Vector Sort ()
        {
            int temp;
            for (int i = 0; i < arr.Length - 1; i++)
            {
                for (int j = i + 1; j < arr.Length; j++)
                {
                    if (arr[i] > arr[j])
                    {
                        temp = arr[i];
                        arr[i] = arr[j];
                        arr[j] = temp;
                    }
                }
            }
            return this;
        }


        public static int operator * (Vector v1, Vector v2)
        {
            if (v1.Length != v2.Length)
                throw new ArgumentException ();
            int result = 0;
            for (int i = 0; i < v1.Length; i++)
                result += v1[i] * v2[i];
            return result;
        }

        public static Vector operator * (Vector v1, int n)
        {
            Vector result = new Vector (v1.Length);
            for (int i = 0; i < v1.Length; i++)
                result[i] = v1[i] * n;
            return result;
        }

        public static Vector operator + (Vector v1, Vector v2)
        {
            if (v1.Length != v2.Length)
                throw new ArgumentException ();
            Vector result = new Vector (v1.Length);
            for (int i = 0; i < v1.Length; i++)
                result[i] = v1[i] + v2[i];
            return result;
        }

        public static Vector operator - (Vector v1, Vector v2)
        {
            if (v1.Length != v2.Length)
                throw new ArgumentException ();
            Vector result = new Vector (v1.Length);
            for (int i = 0; i < v1.Length; i++)
                result[i] = v1[i] - v2[i];
            return result;
        }

        public override string ToString ()
        {
            string result = "";
            for (int i = 0; i < Length; i++)
                result += arr[i] + " ";
            return result;
        }
    }
}