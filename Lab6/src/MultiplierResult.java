/**
 * Created by Makarenko on 06.04.2018.
 */
public class MultiplierResult {
    private int[][] result;

    private final Object monitor = new Object();

    public MultiplierResult(int length) {
        result = DataHelper.GetMatrixOfZero(length);
    }

    public void ApplyResult(int[][] m, int start, int end) {
        synchronized (monitor) {
            for (int i = start; i < end; i++) {
                result[i] = m[i];
            }
        }
    }

    public int[][] GetResult() {
        return result;
    }
}
