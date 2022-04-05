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

    public static Json.Node list_to_json (Gee.List<Person> list) {
        var node_array = new Json.Array.sized (list.size);

        list.foreach ((element) => {
            node_array.add_element (element.to_json ());
            return true;
        });

        var node = new Json.Node (Json.NodeType.ARRAY);
        node.set_array (node_array);
        return node;
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

    public bool equal (Vamp.Person other) {
        return this.name == other.name
            && this.email == other.email
            && this.url == other.url;
    }
}
