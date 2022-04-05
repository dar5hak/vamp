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
        var obj = new Json.Object ();


        if (this.repository_type != null) {
            obj.set_string_member ("type", this.repository_type);
        }

        if (this.url != null) {
            obj.set_string_member ("url", this.url);
        }

        var result = new Json.Node (Json.NodeType.OBJECT);
        result.set_object (obj);

        return result;
    }

    public bool equal (Vamp.Repository other) {
        return this.repository_type == other.repository_type
            && this.url == other.url
            && this.directory == other.directory;
    }
}
