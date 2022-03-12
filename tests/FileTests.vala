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

                    Vamp.Package package = desrialise_package_config (package_contents);
                    assert_cmpstr (package.name, GLib.CompareOperator.EQ, "test-project");
                    assert_cmpstr (package.version, GLib.CompareOperator.EQ, "0.0.1");
                    assert_cmpstr (package.description, GLib.CompareOperator.EQ, "A Test Project");
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

                    Vamp.Package package = desrialise_package_config (package_contents);
                    assert_cmpstr (package.name, GLib.CompareOperator.EQ, "test-project");
                    assert_cmpstr (package.version, GLib.CompareOperator.EQ, "0.0.1");
                    assert_cmpstr (package.description, GLib.CompareOperator.EQ, "A Test Project");
                    assert_cmpstrv (package.keywords.to_array (), {"test", "project", "fake", "mock"});
                    assert_cmpstr (package.homepage, GLib.CompareOperator.EQ, "https://wwww.test.com");

                    // Assert bugs
                    assert_cmpstr (package.bugs.url, GLib.CompareOperator.EQ, "https://www.notgithub.com/owner/project/issues");
                    assert_cmpstr (package.bugs.email, GLib.CompareOperator.EQ, "bugs@test.com");

                    assert_cmpstr (package.license, GLib.CompareOperator.EQ, "MIT");

                    // Assert author
                    assert_cmpstr (package.author.name, CompareOperator.EQ, "vamp-dev");
                    assert_cmpstr (package.author.email, CompareOperator.EQ, "vamp-dev@vamp.org");
                    assert_cmpstr (package.author.url, CompareOperator.EQ, "https://vamp-dev.com");

                    Test.message ("Package dependencies: %s\n", package.dependencies["json-glib"]);
                    Test.message ("Package developer dependencies: %s\n", package.dev_dependencies["g-ir-compiler"]);
                    Test.message ("Package optional dependencies: %s\n", package.optional_dependencies["valadoc"]);
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
