public class Multiplier extends Thread {

    private int[][] result;
    private int[][] m1;
    private int[][] m2;
    private int start;
    private int end;
    private MultiplierResult multiplierResult;

    public Multiplier(int[][] m1, int[][] m2, int start, int end, MultiplierResult multiplierResult) {
        this.m1 = m1;
        this.m2 = m2;
        this.start = start;
        this.end = end;
        this.multiplierResult = multiplierResult;
    }

    @Override
    public void run() {
        result = DataHelper.GetMatrixOfZero(m1.length);
        for (int k = 0; k < m1.length; k++) {
            for (int i = start; i < end; i++) {
                int t = 0;
                for (int j = 0; j < m1.length; j++)
                    t += m1[i][j] * m2[j][k];
                result[i][k] = t;
            }
        }

        multiplierResult.ApplyResult(result, start, end);
    }

    public int[][] GetResult() {
        return result;
    }

    public int GetLength() {
        return end - start;
    }
}
