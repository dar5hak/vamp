public class Vamp.Package : Object, Json.Serializable {
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

                return true;

            case "dependencies":
            case "dev-dependencies":
            case "optional-dependencies":
                if (property_node.get_node_type () != OBJECT) {
                    @value = {};
                    return false;
                }

                @value = string_map_from_json (property_node);

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

    private Json.Node serialize_property (
        string property_name,
        Value value_to_serialize,
        ParamSpec pspec
    ) {
        switch (property_name) {
            case "keywords":
                Test.message ("Value type: %s", value_to_serialize.type_name ());
                var converted_value = (Gee.List<string>)value_to_serialize.get_object ();
                if (converted_value == null) {
                    var blank_array_node = new Json.Node (Json.NodeType.ARRAY);
                    blank_array_node.set_array (new Json.Array ());
                    return null;
                }

                Test.message ("Converted value size: %d", converted_value.size);
                return string_list_to_json (converted_value);
            default:
                return default_serialize_property (
                    property_name,
                    value_to_serialize,
                    pspec
                );
        }
    }
}

public class Vamp.Repository : Object {
    public string repository_type { get; set; }
    public string url { get; set; }
    public string directory { get; set; }

    public static Repository from_json (Json.Node node) {
        assert (node.get_node_type () == OBJECT);
        var result = new Repository ();

        var obj = node.get_object ();
        obj.get_members ().foreach ((member_name) => {
            switch (member_name) {
                case "type":
                    result.repository_type = obj.get_string_member (member_name);
                    break;
                default:
                    result.set_property (member_name, obj.get_string_member (member_name));
                    break;
            }
        });

        return result;
    }

    public Json.Node to_json () {
        return Json.gobject_serialize (this);
    }

    public bool equals (Vamp.Repository other) {
        return this.repository_type == other.repository_type
            && this.url == other.url
            && this.directory == other.directory;
    }
}

public class Vamp.FundingInfo : Object {
    public string funding_type { get; set; }
    public string url { get; set; }

    public static FundingInfo from_json (Json.Node node) {
        assert (node.get_node_type () == OBJECT);
        var result = new FundingInfo ();

        var obj = node.get_object ();
        obj.get_members ().foreach ((member_name) => {
            switch (member_name) {
                case "type":
                    result.funding_type = obj.get_string_member (member_name);
                    break;
                default:
                    result.set_property (member_name, obj.get_string_member (member_name));
                    break;
            }
        });

        return result;
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

    public bool equals (Vamp.FundingInfo other) {
        return this.funding_type == other.funding_type
            && this.url == other.url;
    }
}

public class Vamp.Person : Object {
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

    public bool equals (Vamp.Person other) {
        return this.name == other.name
            && this.email == other.email
            && this.url == other.url;
    }
}

public class Vamp.Bugs : Object {
    public string url { get; set; }
    public string email { get; set; }

    public static Bugs from_json (Json.Node node) {
        assert (node.get_node_type () == OBJECT);
        return (Bugs) Json.gobject_deserialize (typeof (Bugs), node);
    }

    public Json.Node to_json () {
        return Json.gobject_serialize (this);
    }

    public bool equals (Vamp.Bugs other) {
        return this.url == other.url
            && this.email == other.email;
    }
}

Json.Node string_list_to_json (Gee.List<string> list) {
    var node_array = new Json.Array.sized (list.size);
    list.foreach ((element) => {
        node_array.add_string_element (element);
        return true;
    });

    var node = new Json.Node (Json.NodeType.ARRAY);
    node.set_array (node_array);
    return node;
}

Gee.List<string> string_list_from_json (Json.Node node) {
    assert (node.get_node_type () == ARRAY);

    var array = node.get_array ();
    var result = new Gee.ArrayList<string> ();

    array.foreach_element ((_, __, element_node) => {
        if (element_node.get_value_type () != Type.STRING) {
            return;
        }

        result.add (element_node.get_string ());
    });

    return result;
}

Gee.Map<string, string> string_map_from_json (Json.Node node) {
    assert (node.get_node_type () == OBJECT);

    var result = new Gee.HashMap<string, string> ();

    node.get_object ().foreach_member ((obj, member_name, member_node) => {
        result.set (member_name, member_node.get_string ());
    });

    return result;
}
