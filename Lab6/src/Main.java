public class Main {
    // N = (MO * MP)*(R + T)
    public static void main(String[] args) {
        Data d = new Data();
        int size = 3;
        System.out.println("N = (MO * MP)*(R + T)");
        System.out.println("N:");
        try {
            DataHelper.printVector(d.Func(
                    DataHelper.GetMatrixOfOne(size),
                    DataHelper.GetMatrixOfOne(size),
                    DataHelper.GetVectorOfOne(size),
                    DataHelper.GetVectorOfOne(size)
            ));
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
    }
}
