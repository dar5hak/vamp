namespace Vamp {
    class FileTest {
        public static int main () {
            string package_contents;
            try {
                bool did_open = FileUtils.get_contents (TestConfig.TEST_PACKAGE_FILE, out package_contents);
                if (!did_open) {
                    error ("Failed to get contents from: %s".printf (TestConfig.TEST_PACKAGE_FILE));
                }
                print ("Test package file contents:\n%s", package_contents);
                desrialise_package_config (package_contents);
            } catch (FileError e) {
                error (e.message);
            }
            return 0;
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
