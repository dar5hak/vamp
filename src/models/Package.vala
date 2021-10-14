class Vamp.Package : Object, Json.Serializable {
    public string name { get; set; }
    public string version { get; set; }
    public string description { get; set; }
    public Gee.List<string> keywords { get; set; }
    public string homepage { get; set; }
    public Bugs bugs { get; set; }
    public string license { get; set; }
    public Person author { get; set; }
    public Gee.List<Person> contributors { get; set; }
    public Gee.List<FundingInfo> funding { get; set; }
    public Gee.List<string> files { get; set; }
    public Repository repository { get; set; }
    public Gee.Map<string, string> dependencies { get; set; }
    public Gee.Map<string, string> dev_dependencies { get; set; }
    public Gee.Map<string, string> optional_dependencies { get; set; }

    public static Package from_json (Json.Node node) {
        assert (node.get_node_type () == OBJECT);
        return (Package) Json.gobject_deserialize (typeof (Package), node);
    }

    public Json.Node to_json () {
        return Json.gobject_serialize (this);
    }

    private bool deserialize_property (
        string property_name,
        out Value @value,
        ParamSpec pspec,
        Json.Node property_node
    ) {
        switch (property_name) {
            case "keywords":
                if (property_node.get_node_type () != ARRAY) {
                    @value = {};
                    return false;
                }

                @value = string_list_from_json (property_node);

                return true;

            case "bugs":
                if (property_node.get_node_type () == OBJECT) {
                    @value = Bugs.from_json (property_node);
                    return true;
                }

                if (property_node.get_value_type () != Type.STRING) {
                    @value = {};
                    return false;
                }

                @value = new Bugs () {
                    url = property_node.get_string (),
                };

                return true;

            case "author":
                if (property_node.get_node_type () == OBJECT) {
                    @value = Person.from_json (property_node);
                    return true;
                }

                if (property_node.get_value_type () != Type.STRING) {
                    @value = {};
                    return false;
                }

                return Person.try_parse (property_node.get_string (), out @value);
            
            case "contributors":
                if (property_node.get_node_type () != ARRAY) {
                    @value = {};
                    return false;
                }

                @value = Person.list_from_json (property_node);

                return true;

            case "funding":
                if (property_node.get_node_type () != ARRAY) {
                    @value = {};
                    return false;
                }

                @value = FundingInfo.list_from_json (property_node);

                return true;
            
            case "files":
                if (property_node.get_node_type () != ARRAY) {
                    @value = {};
                    return false;
                }

                @value = string_list_from_json (property_node);

                return true;
            
            case "repository":
                if (property_node.get_node_type () != OBJECT) {
                    @value = {};
                    return false;
                }

                @value = Repository.from_json (property_node);

                return false;

            case "dependencies":
                return true;
            
            case "dev-dependencies":
                return true;
            
            case "optional-dependencies":
                return true;

            default:
                return default_deserialize_property (
                    property_name,
                    out @value,
                    pspec,
                    property_node
                );
        }
    }
}

class Vamp.Repository : Object {
    public string type { get; set; }
    public string url { get; set; }
    public string directory { get; set; }

    public static Repository from_json (Json.Node node) {
        assert (node.get_node_type () == OBJECT);
        return (Repository) Json.gobject_deserialize (typeof (Repository), node);
    }

    public Json.Node to_json () {
        return Json.gobject_serialize (this);
    }
}

class Vamp.FundingInfo : Object {
    public string type { get; set; }
    public string url { get; set; }

    public static FundingInfo from_json (Json.Node node) {
        assert (node.get_node_type () == OBJECT);
        return (FundingInfo) Json.gobject_deserialize (typeof (FundingInfo), node);
    }

    public static Gee.List<FundingInfo> list_from_json (Json.Node node) {
        assert (node.get_node_type () == ARRAY);
        
        var array = node.get_array ();
        var result = new Gee.ArrayList<FundingInfo> ();

        array.foreach_element ((_, __, element_node) => {
            if (element_node.get_node_type () != OBJECT) {
                return;
            }

            result.add (FundingInfo.from_json (element_node));
        });

        return result;
    }

    public Json.Node to_json () {
        return Json.gobject_serialize (this);
    }
}

class Vamp.Person : Object {
    private static Regex regex = /^(.*)(?:\s)(<.*>)(?:\s)(\(.*\))/; // vala-lint=space-before-paren

    public string name { get; set; }
    public string email { get; set; }
    public string url { get; set; }

    public static Person from_json (Json.Node node) {
        assert (node.get_node_type () == OBJECT);
        return (Person) Json.gobject_deserialize (typeof (Person), node);
    }

    public static Gee.List<Person> list_from_json (Json.Node node) {
        assert (node.get_node_type () == ARRAY);

        var array = node.get_array ();
        var result = new Gee.ArrayList<Person> ();

        array.foreach_element ((_, __, element_node) => {
            if (element_node.get_node_type () != OBJECT) {
                return;
            }

            result.add (Person.from_json (element_node));
        });

        return result;
    }

    public static bool try_parse (string str, out Person result) {
        MatchInfo info;

        if (!Person.regex.match (str, 0, out info)) {
            result = null;
            return false;
        }

        result = new Person () {
            name = info.fetch (1),
            email = info.fetch (2),
            url = info.fetch (3),
        };

        return true;
    }

    public Json.Node to_json () {
        return Json.gobject_serialize (this);
    }
}

class Vamp.Bugs : Object {
    public string url { get; set; }
    public string email { get; set; }

    public static Bugs from_json (Json.Node node) {
        assert (node.get_node_type () == OBJECT);
        return (Bugs) Json.gobject_deserialize (typeof (Bugs), node);
    }

    public Json.Node to_json () {
        return Json.gobject_serialize (this);
    }
}

Gee.List<string> string_list_from_json (Json.Node node) {
    assert (node.get_node_type () == ARRAY);

    var array = node.get_array ();
    var result = new Gee.ArrayList<string> ();

    array.foreach_element ((_, __, element_node) => {
        if (element_node.get_value_type () == Type.STRING) {
            return;
        }

        result.add (element_node.get_string ());
    });

    return result;
}
