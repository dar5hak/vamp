namespace Vamp {
    class UnitTests {
        public static int main (string[] args) {
            Test.init (ref args);

            Test.add_func ("/vamp/foo", () => {
                assert_null (null);
            });

            Test.add_func ("/vamp/bar", () => {
                assert_true (true);
            });

            return Test.run ();
        }
    }
}
