namespace Vamp {
    class Test {
        public static int main (string[] args) {
            GLib.Test.init (ref args);

            GLib.Test.add_func ("/vamp/foo", () => {
                assert_null (null);
            });

            GLib.Test.add_func ("/vamp/bar", () => {
                assert_true (true);
            });

            return GLib.Test.run ();
        }
    }
}
