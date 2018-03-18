using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Lab3
{
    class Matrix
    {
        private static int _taskNum = 4;
        public static int TaskNum
        {
            get
            {
                return _taskNum;
            }
            set
            {
                if (value < 1)
                    throw new ArgumentException ("number of tasks cannot be less than 1");
                _taskNum = value;
            }
        }
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
            // for (int i = 0; i < n; i++)
            //     result[i] = new Vector (n);
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

        public static Task<Matrix> MultiplyAsync (Matrix m1, Matrix m2)
        {
            if (m1.Length != m2.Length)
                throw new ArgumentException ();

            int workTasks = TaskNum < m1.Length? TaskNum: m1.Length;

            int block = m1.Length / workTasks;
            int rest = m1.Length % workTasks;

            return Task.Factory.StartNew (() =>
            {
                var result = new Matrix (m1.Length);

                if (TaskNum == 1)
                    return m1 * m2;

                List<Task<Vector[]>> tasks = new List<Task<Vector[]>> (workTasks);
                for (int i = 0; i < workTasks; i++)
                {
                    tasks.Add (Matrix.mutiplyPart (m1, m2, i * block, i * block + block));
                    if (rest != 0 && i == workTasks - 1)
                        tasks.Add (Matrix.mutiplyPart (m1, m2, i * block, m1.Length));
                }

                // Task.WaitAll (tasks.ToArray ());
                int k = 0;
                for (int i = 0; i <workTasks; i++)
                {
                    for (int j = 0; j < tasks[i].Result.Length; j++)
                    {
                        result[k] = tasks[i].Result[j];
                        k++;
                    }
                }

                return result;
            });
        }

        private static Task<Vector[]> mutiplyPart (Matrix m1, Matrix m2, int from, int to)
        {
            return Task.Factory.StartNew (() =>
            {
                var result = new Vector[to - from];
                for (int i = 0; i < result.Length; i++)
                    result[i] = new Vector (m1.Length);
                for (int k = 0; k < m1.Length; k++)
                {
                    for (var i = from; i < to; i++)
                    {
                        int t = 0;
                        for (int j = 0; j < m1.Length; j++)
                            t += m1[i][j] * m2[j][k];
                        result[i - from][k] = t;
                    }
                }
                return result;
            });

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