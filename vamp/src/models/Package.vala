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
        assert (node.get_node_type () == Json.NodeType.OBJECT);
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
                if (property_node.get_node_type () != Json.NodeType.ARRAY) {
                    @value = {};
                    return false;
                }

                @value = string_list_from_json (property_node);

                return true;

            case "bugs":
                if (property_node.get_node_type () == Json.NodeType.OBJECT) {
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
                if (property_node.get_node_type () == Json.NodeType.OBJECT) {
                    @value = Person.from_json (property_node);
                    return true;
                }

                if (property_node.get_value_type () != Type.STRING) {
                    @value = {};
                    return false;
                }

                return Person.try_parse (property_node.get_string (), out @value);

            case "contributors":
                if (property_node.get_node_type () != Json.NodeType.ARRAY) {
                    @value = {};
                    return false;
                }

                @value = Person.list_from_json (property_node);

                return true;

            case "funding":
                if (property_node.get_node_type () != Json.NodeType.ARRAY) {
                    @value = {};
                    return false;
                }

                @value = FundingInfo.list_from_json (property_node);

                return true;

            case "files":
                if (property_node.get_node_type () != Json.NodeType.ARRAY) {
                    @value = {};
                    return false;
                }

                @value = string_list_from_json (property_node);

                return true;

            case "repository":
                if (property_node.get_node_type () != Json.NodeType.OBJECT) {
                    @value = {};
                    return false;
                }

                @value = Repository.from_json (property_node);

                return true;

            case "dependencies":
            case "dev-dependencies":
            case "optional-dependencies":
                if (property_node.get_node_type () != Json.NodeType.OBJECT) {
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
            case "files":
                Gee.List<string> converted_value = (Gee.List<string>)value_to_serialize.get_object ();
                if (converted_value == null) {
                    return null;
                }

                return string_list_to_json (converted_value);

            case "contributors":
                Gee.List<Person> converted_value = (Gee.List<Person>)value_to_serialize.get_object ();
                if (converted_value == null) {
                    return null;
                }

                return Person.list_to_json (converted_value);

            case "funding":
                Gee.List<FundingInfo> converted_value = (Gee.List<FundingInfo>)value_to_serialize.get_object ();
                if (converted_value == null) {
                    return null;
                }

                return FundingInfo.list_to_json (converted_value);

            case "repository":
                Vamp.Repository converted_value = (Vamp.Repository)value_to_serialize.get_object ();

                if (converted_value == null) {
                    return null;
                }

                return converted_value.to_json ();

            case "dependencies":
            case "dev-dependencies":
            case "optional-dependencies":
                Gee.Map<string, string> converted_value = (Gee.Map<string, string>)value_to_serialize.get_object ();

                if (converted_value == null) {
                    return null;
                }

                return string_map_to_json (converted_value);

            default:
                return default_serialize_property (
                    property_name,
                    value_to_serialize,
                    pspec
                );
        }
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
    assert (node.get_node_type () == Json.NodeType.ARRAY);

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


Json.Node string_map_to_json (Gee.Map<string, string> map) {
    var node_object = new Json.Object ();
    map.entries.foreach ((entry) => {
        node_object.set_string_member (entry.key, entry.value);
        return true;
    });

    var node = new Json.Node (Json.NodeType.OBJECT);
    node.set_object (node_object);

    return node;
}

Gee.Map<string, string> string_map_from_json (Json.Node node) {
    assert (node.get_node_type () == Json.NodeType.OBJECT);

    var result = new Gee.HashMap<string, string> ();

    node.get_object ().foreach_member ((obj, member_name, member_node) => {
        result.set (member_name, member_node.get_string ());
    });

    return result;
}
