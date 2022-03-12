namespace Vamp {
    class FileTest {
        public static int main (string[] args) {
            Test.init (ref args);

            Test.add_func ("/vamp/basic_config", () => {
                string package_contents;
                try {
                    bool did_open = FileUtils.get_contents (TestConfig.TEST_PACKAGE_FILE, out package_contents);
                    if (!did_open) {
                        error ("Failed to get contents from: %s".printf (TestConfig.TEST_PACKAGE_FILE));
                }
                    Test.message ("Test package file contents:\n%s", package_contents);
                    Vamp.Package package = desrialise_package_config (package_contents);
                    Test.message ("Package name: %s\n", package.name);
                    Test.message ("Package version: %s\n", package.version);
                    Test.message ("Package description: %s\n", package.description);
                } catch (FileError e) {
                    error (e.message);
                }
            });

            Test.add_func ("/vamp/full_config", () => {
                string package_contents;
                try {
                    bool did_open = FileUtils.get_contents (TestConfig.FULL_TEST_PACKAGE_FILE, out package_contents);
                    if (!did_open) {
                        error ("Failed to get contents from: %s".printf (TestConfig.FULL_TEST_PACKAGE_FILE));
                }
                    Test.message ("Test package file contents:\n%s", package_contents);
                    Vamp.Package package = desrialise_package_config (package_contents);
                    Test.message ("Package name: %s\n", package.name);
                    Test.message ("Package version: %s\n", package.version);
                    Test.message ("Package description: %s\n", package.description);
                } catch (FileError e) {
                    error (e.message);
                }
            });

            return Test.run ();
        }

        private static Vamp.Package desrialise_package_config (string config_data) {
            var parser = new Json.Parser ();
            try {
                parser.load_from_data (config_data);
                return Vamp.Package.from_json (parser.get_root ());
            } catch (Error e) {
                error ("Unable to parse the package config data: %s\n", e.message);
            }
        }
    }
}
