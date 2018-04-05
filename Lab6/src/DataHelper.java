import java.util.Random;

/**
 * Created by Makarenko on 05.04.2018.
 */
public class DataHelper {
    public static void printVector(int[] v) {
        for (int i = 0; i < v.length; i++)
            System.out.print(v[i] + " ");
        System.out.println();
    }

    public static void printMatrix(int[][] m) {
        for (int i = 0; i < m.length; i++)
            printVector(m[i]);
        System.out.println();
    }

    public static int GetRandomNumber() {
        Random rand = new Random();
        return rand.nextInt();
    }

    public static int[] GetRandomVector(int length) {
        int[] result = new int[length];
        for (int i = 0; i < length; i++)
            result[i] = GetRandomNumber();
        return result;
    }

    public static int[][] GetRandomMatrix(int length) {
        int result[][] = new int[length][];
        for (int i = 0; i < length; i++)
            result[i] = GetRandomVector(length);
        return result;
    }

    public static int[] GetVectorOfZero(int length) {
        int[] result = new int[length];
        for (int i = 0; i < length; i++)
            result[i] = 0;
        return result;
    }

    public static int[][] GetMatrixOfZero(int length) {
        int result[][] = new int[length][];
        for (int i = 0; i < length; i++)
            result[i] = GetVectorOfZero(length);
        return result;
    }

    public static int[] GetVectorOfOne(int length) {
        int[] result = new int[length];
        for (int i = 0; i < length; i++)
            result[i] = 1;
        return result;
    }

    public static int[][] GetMatrixOfOne(int length) {
        int result[][] = new int[length][];
        for (int i = 0; i < length; i++)
            result[i] = GetVectorOfOne(length);
        return result;
    }

    public static int[] MatrixToVectorHorizontal(int[][] m, int n) {
        int[] result = new int[m.length];

        for (int i = 0; i < m.length; i++) {
            result[i] = m[n][i];
        }
        return result;
    }

    public static int[] MatrixToVectorVertical(int[][] m, int n) {
        int[] result = new int[m.length];

        for (int i = 0; i < m.length; i++) {
            result[i] = m[i][n];
        }
        return result;
    }

    public static int[][] VectorToMatrixHorizontal(int[] l, int n) {
        int[][] result = GetMatrixOfZero(l.length);

        for (int i = 0; i < l.length; i++) {
            result[n][i] = l[i];
        }
        return result;
    }

    public static int[][] VectorToMatrixVertical(int[] l, int n) {
        int[][] result = GetMatrixOfZero(l.length);

        for (int i = 0; i < l.length; i++) {
            result[i][n] = l[i];
        }
        return result;
    }
}
