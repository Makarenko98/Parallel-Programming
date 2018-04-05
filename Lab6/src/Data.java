// N = (MO * MP)*(R + T)
public class Data {
    private static final int THREAD_NUM = 4;

    static final Object mutex = new Object();

    public int[] Func(int[][] MO, int[][] MP, int[] R, int[] T) throws InterruptedException {
        return DataHelper.MatrixToVectorVertical(
                multiplyMatrixParallel(
                        multiplyMatrixParallel(MO, MP),
                        DataHelper.VectorToMatrixVertical(sumVector(R, T), 0)),
                0);
    }

    public int[] sumVector(int[] v1, int[] v2) {
        int[] result = new int[v1.length];
        for (int i = 0; i < v1.length; i++)
            result[i] = v1[i] + v2[i];
        return result;
    }

    public int[][] SumvMatrix(int[][] m1, int[][] m2) {
        int[][] result = new int[m1.length][];
        for (int i = 0; i < m1.length; i++)
            result[i] = sumVector(m1[i], m2[i]);
        return result;
    }

    public int dotProduct(int[] v1, int[] v2) {
        int result = 0;
        for (int i = 0; i < v1.length; i++)
            result += v1[i] * v2[i];
        return result;
    }

    public int[] sortVector(int[] arr) {
        int temp;

        for (int i = 0; i < arr.length - 1; i++) {
            for (int j = i + 1; j < arr.length; j++) {
                if (arr[i] > arr[j]) {
                    temp = arr[i];
                    arr[i] = arr[j];
                    arr[j] = temp;
                }
            }
        }
        return arr;
    }

    public int[] multVectorNumber(int[] v, int n) {
        int[] result = new int[v.length];
        for (int i = 0; i < v.length; i++)
            result[i] = v[i] * n;
        return result;
    }

    public int[][] multMatrixNumber(int[][] m, int n) {
        int[][] result = new int[m.length][];
        for (int i = 0; i < m.length; i++)
            result[i] = multVectorNumber(m[i], n);
        return result;
    }

    public int[][] multiplyMatrixParallel(int[][] m1, int[][] m2) throws InterruptedException {
        int[][] result = DataHelper.GetMatrixOfZero(m1.length);
        if (m1.length == 1) {
            return multiplyMatrix(m1, m2);
        }
        int thrdsNum = m1.length < THREAD_NUM ? m1.length : THREAD_NUM;
        int block = m1.length / thrdsNum;
        int rest = m1.length % thrdsNum;
        int lastThread = thrdsNum + (rest != 0 ? 1 : 0);

        Multiplier[] threads = new Multiplier[lastThread];

        MultiplierResult multiplierResult = new MultiplierResult(m1.length);

        for (int i = 0; i < thrdsNum; i++) {
            threads[i] = new Multiplier(m1, m2, i * block, i * block + block, multiplierResult);
            threads[i].start();
        }
        if (rest != 0) {
            threads[lastThread] = new Multiplier(m1, m2, thrdsNum * block, m1.length, multiplierResult);
            threads[lastThread].start();
        }
        for (int i = 0; i < lastThread; i++) {
            threads[i].join();
        }

        return multiplierResult.GetResult();
    }

    public int[][] multiplyMatrix(int[][] m1, int[][] m2) {
        int[][] result = new int[m1.length][];
        for (int i = 0; i < m1.length; i++)
            result[i] = new int[m1.length];
        for (int k = 0; k < m1.length; k++) {
            for (int i = 0; i < m1.length; i++) {
                int t = 0;
                for (int j = 0; j < m1.length; j++)
                    t += m1[i][j] * m2[j][k];
                result[i][k] = t;
            }
        }
        return result;
    }
}