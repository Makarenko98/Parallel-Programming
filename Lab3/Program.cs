using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

// T = sort(O+T)*trans(MR*MS)

namespace Lab3
{
    class Program
    {
        static void Main (string[] args)
        {
            // int workerThreads, completionPortThreads;
            // ThreadPool.GetMinThreads(out workerThreads, out completionPortThreads);
            // System.Console.WriteLine(workerThreads + " " +completionPortThreads);
            var timer = Stopwatch.StartNew ();
            System.Console.WriteLine ("Enter N:");
            int N = int.Parse (Console.ReadLine ());
            System.Console.WriteLine ("Result:");
            var task = Calculate (N);

            task.Wait ();
            timer.Stop ();
            System.Console.WriteLine ("Elapsed time: " + timer.Elapsed);
            Console.ReadKey ();
        }

        public async static Task Calculate (int N)
        {
            var O = Vector.GetVectorOfOne (N);
            var T = Vector.GetVectorOfOne (N);
            var MR = Matrix.GetMatrixOfOne (N);
            var MS = Matrix.GetMatrixOfOne (N);

            var oPlusTtask = SumVectors (O, T);
            var sortVecotrsTask = SortVecotrs (oPlusTtask);
            var multiplyMatrixTask = MultiplyMatrix (MR, MS);
            var transMatrixTask = TransMatrix (multiplyMatrixTask);

            O = await sortVecotrsTask;
            MR = await transMatrixTask;

            var Om = Matrix.GetMatrixOfZero (N);

            Om[0] = O;

            System.Console.WriteLine ((Om * MR) [0]);
        }

        public static Task<Vector> SumVectors (Vector O, Vector T)
        {
            return Task.Factory.StartNew (() => O + T);
        }

        public static Task<Vector> SortVecotrs (Task<Vector> oPlusTtask)
        {
            return Task.Factory.StartNew (() => oPlusTtask.Result.Sort ());
        }

        public static Task<Matrix> MultiplyMatrix (Matrix MR, Matrix MS)
        {
            // return Task.Factory.StartNew (() => MR * MS);
            return Matrix.MultiplyAsync (MR, MS);
        }

        public static Task<Matrix> TransMatrix (Task<Matrix> multMatrixTask)
        {
            return Task.Factory.StartNew (() => multMatrixTask.Result.TransMatrix ());
        }
    }
}