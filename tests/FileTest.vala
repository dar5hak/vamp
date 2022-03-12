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
            } catch (FileError e) {
                error (e.message);
            }
            return 0;
        }
    }
}
