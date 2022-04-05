namespace Vamp {
    class UnitTests {
        public static int main (string[] args) {
            Test.init (ref args);

            Test.add_func ("/vamp/deserialize_basic_config", () => {
                string package_contents;
                try {
                    bool did_open = FileUtils.get_contents (TestConfig.TEST_PACKAGE_FILE, out package_contents);
                    if (!did_open) {
                        error ("Failed to get contents from: %s".printf (TestConfig.TEST_PACKAGE_FILE));
                    }

                    Vamp.Package package = desrialise_package_config (package_contents);
                    assert (package.name == "test-project");
                    assert (package.version == "0.0.1");
                    assert (package.description == "A Test Project");
                } catch (FileError e) {
                    error (e.message);
                }
            });

            Test.add_func ("/vamp/deserialize_full_config", () => {
                string package_contents;
                try {
                    bool did_open = FileUtils.get_contents (TestConfig.FULL_TEST_PACKAGE_FILE, out package_contents);
                    if (!did_open) {
                        error ("Failed to get contents from: %s".printf (TestConfig.FULL_TEST_PACKAGE_FILE));
                    }

                    Vamp.Package package = desrialise_package_config (package_contents);
                    assert (package.name == "test-project");
                    assert (package.version == "0.0.1");
                    assert (package.description == "A Test Project");
                    assert (package.keywords.contains_all_array ({"test", "project", "fake", "mock"}));
                    assert (package.homepage == "https://wwww.test.com");

                    // We assert objects this way so that:
                    // 1. We know the exact value of each object property
                    // 2. We can easily update our asserts as we update the
                    // object's properties.
                    assert_full_config_bugs (package.bugs);
                    assert (package.license == "MIT");
                    assert_full_config_author (package.author);
                    assert_full_config_contributors (package.contributors);
                    assert_full_config_funding (package.funding);
                    assert (package.files.contains_all_array ({"./main-module/**/*", "./extra-module/**/*"}));
                    assert_full_config_respository (package.repository);
                    assert_full_config_dependencies (package.dependencies);
                    assert_full_config_dev_dependencies (package.dev_dependencies);
                    assert_full_config_optional_dependencies (package.optional_dependencies);
                } catch (FileError e) {
                    error (e.message);
                }
            });

            Test.add_func ("/vamp/serialize_basic_config", () => {
                Vamp.Package package = new Vamp.Package ();
                package.name = "basic-project";
                package.version = "1.0.0";
                package.description = "A basic project";

                var generator = new Json.Generator ();
                generator.pretty = true;
                generator.indent = 4;
                generator.set_root (package.to_json ());
                try {
                    string expected_content;
                    bool did_open = FileUtils.get_contents (TestConfig.BASIC_EXPECTED_TEST_PACKAGE_FILE,
                        out expected_content
                    );

                    if (!did_open) {
                        error ("Failed to get contents from: %s".printf (TestConfig.BASIC_EXPECTED_TEST_PACKAGE_FILE));
                    }

                    assert (generator.to_data (null) == expected_content);

                } catch (Error e) {
                    error (e.message);
                }
            });

            Test.add_func ("/vamp/serialize_full_config", () => {
                Vamp.Package package = new Vamp.Package ();
                package.name = "full-project";
                package.version = "1.0.0";
                package.description = "A full project";
                package.keywords = new Gee.ArrayList<string>.wrap ({"full", "project"});
                package.homepage = "https://www.full-project.com";
                package.bugs = new Bugs () {
                    url = "https://www.full-project.com/bugs",
                    email = "bugs@full-project.com"
                };

                package.license = "MIT";
                package.author = new Person () {
                    name = "vamp-dev",
                    email = "vamp-dev@vamp.org",
                    url = "https://www.vamp-dev.com"
                };

                package.contributors = new Gee.ArrayList<Person>.wrap ({
                    new Person () {
                        name = "vamp-dev-2",
                        email = "vamp-dev-2@vamp.org",
                        url = "https://www.vamp-dev-2.com"
                    },
                    new Person () {
                        name = "vamp-dev-3",
                        email = "vamp-dev-3@vamp.org",
                        url = "https://www.vamp-dev-3.com"
                    },
                });

                package.funding = new Gee.ArrayList<FundingInfo>.wrap ({
                    new FundingInfo () {
                        funding_type = "individual",
                        url = "https://www.vamp.com/donate"
                    }
                });

                package.files = new Gee.ArrayList<string>.wrap ({
                    "./main-module/**/*",
                    "./extra-module/**/*"
                });

                package.repository = new Repository () {
                    repository_type = "git",
                    url = "https://www.notgithub.com/owner/project"
                };

                var dependencies = new Gee.HashMap<string, string> ();
                dependencies["json-glib"] = "^1.0.0";
                package.dependencies = dependencies;

                var dev_dependencies = new Gee.HashMap<string, string> ();
                dev_dependencies["g-ir-compiler"] = "^1.2.0";
                package.dev_dependencies = dev_dependencies;

                var optional_dependencies = new Gee.HashMap<string, string> ();
                optional_dependencies["valadoc"] = "^0.56.0";
                package.optional_dependencies = optional_dependencies;

                var generator = new Json.Generator ();
                generator.pretty = true;
                generator.indent = 4;
                generator.set_root (package.to_json ());
                try {
                    string expected_content;
                    bool did_open = FileUtils.get_contents (TestConfig.FULL_EXPECTED_TEST_PACKAGE_FILE,
                        out expected_content
                    );

                    if (!did_open) {
                        error ("Failed to get contents from: %s".printf (TestConfig.FULL_EXPECTED_TEST_PACKAGE_FILE));
                    }

                    assert (generator.to_data (null) == expected_content);

                } catch (Error e) {
                    error (e.message);
                }
            });

            return Test.run ();
        }

        private static void assert_full_config_optional_dependencies (Gee.Map<string, string> dependencies) {
            assert (dependencies["valadoc"] == "^0.48.0");
        }

        private static void assert_full_config_dev_dependencies (Gee.Map<string, string> dependencies) {
            assert (dependencies["g-ir-compiler"] == "^1.6.0");
        }

        private static void assert_full_config_dependencies (Gee.Map<string, string> dependencies) {
            assert (dependencies["json-glib"] == "^1.6.0");
        }

        private static void assert_full_config_respository (Vamp.Repository repository) {
            assert (repository.repository_type == "git");
            assert (repository.url == "https://www.notgithub.com/owner/project");
        }

        private static void assert_full_config_funding (Gee.List<FundingInfo> funding) {
            for (int i = 0; i < funding.size; i++) {
                FundingInfo funding_info = funding[i];
                switch (i) {
                    case 0:
                        assert (funding_info.funding_type == "individual");
                        assert (funding_info.url == "https://www.vamp.com/donate");
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
                        assert (contributor.name == "vamp-dev-2");
                        assert (contributor.email == "vamp-dev-2@vamp.org");
                        assert (contributor.url == "https://vamp-dev-2.com");
                        break;
                    case 1:
                        assert (contributor.name == "vamp-dev-3");
                        assert (contributor.email == "vamp-dev-3@vamp.org");
                        assert (contributor.url == "https://vamp-dev-3.com");
                        break;
                }

                if (i == contributors.size - 1 && i != 1) {
                    Test.message ("Test failed! - Did not parse 2 contributors.\nParsed: %d contributor(s).", i + 1);
                    Test.fail ();
                }
            }
        }

        private static void assert_full_config_author (Vamp.Person author) {
            assert (author.name == "vamp-dev");
            assert (author.email == "vamp-dev@vamp.org");
            assert (author.url == "https://vamp-dev.com");
        }

        private static void assert_full_config_bugs (Vamp.Bugs bugs) {
            assert (bugs.email == "bugs@test.com");
            assert (bugs.url == "https://www.notgithub.com/owner/project/issues");
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
