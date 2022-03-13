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

                    // We assert objects this way so that:
                    // 1. We know the exact value of each object property
                    // 2. We can easily update our asserts as we update the
                    // object's properties.
                    assert_full_config_bugs (package.bugs);
                    assert_cmpstr (package.license, GLib.CompareOperator.EQ, "MIT");
                    assert_full_config_author (package.author);
                    assert_full_config_contributors (package.contributors);
                    assert_full_config_funding (package.funding);
                    assert_cmpstrv (package.files.to_array (), { "./main-module/**/*", "./extra-module/**/*"});
                    assert_full_config_respository (package.repository);
                    assert_full_config_dependencies (package.dependencies);
                    assert_full_config_dev_dependencies (package.dev_dependencies);
                    assert_full_config_optional_dependencies (package.optional_dependencies);
                } catch (FileError e) {
                    error (e.message);
                }
            });

            return Test.run ();
        }

        private static void assert_full_config_optional_dependencies (Gee.Map<string, string> dependencies) {
            assert_cmpstr (dependencies["valadoc"], GLib.CompareOperator.EQ, "^0.48.0");
        }

        private static void assert_full_config_dev_dependencies (Gee.Map<string, string> dependencies) {
            assert_cmpstr (dependencies["g-ir-compiler"], GLib.CompareOperator.EQ, "^1.6.0");
        }

        private static void assert_full_config_dependencies (Gee.Map<string, string> dependencies) {
            assert_cmpstr (dependencies["json-glib"], GLib.CompareOperator.EQ, "^1.6.0");
        }

        private static void assert_full_config_respository (Vamp.Repository repository) {
            assert_cmpstr (repository.repository_type, GLib.CompareOperator.EQ, "git");
            assert_cmpstr (repository.url, GLib.CompareOperator.EQ, "https://www.notgithub.com/owner/project");
        }

        private static void assert_full_config_funding (Gee.List<FundingInfo> funding) {
            for (int i = 0; i < funding.size; i++) {
                FundingInfo funding_info = funding[i];
                switch (i) {
                    case 0:
                        assert_cmpstr (funding_info.funding_type, CompareOperator.EQ, "individual");
                        assert_cmpstr (funding_info.url, CompareOperator.EQ, "https://www.vamp.com/donate");
                        break;
                }

                if (i == funding.size - 1 && i != 0) {
                    Test.message ("Test failed! - Did not parse 1 funding info item.\n"
                        + "Parsed: %d parsing info item(s).", i + 1
                    );

                    Test.fail ();
                }
            }
        }
        private static void assert_full_config_contributors (Gee.List<Person> contributors) {
            for (int i = 0; i < contributors.size; i++) {
                Person contributor = contributors[i];
                switch (i) {
                    case 0:
                        assert_cmpstr (contributor.name, CompareOperator.EQ, "vamp-dev-2");
                        assert_cmpstr (contributor.email, CompareOperator.EQ, "vamp-dev-2@vamp.org");
                        assert_cmpstr (contributor.url, CompareOperator.EQ, "https://vamp-dev-2.com");
                        break;
                    case 1:
                        assert_cmpstr (contributor.name, CompareOperator.EQ, "vamp-dev-3");
                        assert_cmpstr (contributor.email, CompareOperator.EQ, "vamp-dev-3@vamp.org");
                        assert_cmpstr (contributor.url, CompareOperator.EQ, "https://vamp-dev-3.com");
                        break;
                }

                if (i == contributors.size - 1 && i != 1) {
                    Test.message ("Test failed! - Did not parse 2 contributors.\nParsed: %d contributor(s).", i + 1);
                    Test.fail ();
                }
            }
        }

        private static void assert_full_config_author (Vamp.Person author) {
            assert_cmpstr (author.name, CompareOperator.EQ, "vamp-dev");
            assert_cmpstr (author.email, CompareOperator.EQ, "vamp-dev@vamp.org");
            assert_cmpstr (author.url, CompareOperator.EQ, "https://vamp-dev.com");
        }

        private static void assert_full_config_bugs (Vamp.Bugs bugs) {
            assert_cmpstr (bugs.email, CompareOperator.EQ, "bugs@test.com");
            assert_cmpstr (bugs.url, CompareOperator.EQ, "https://www.notgithub.com/owner/project/issues");
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
