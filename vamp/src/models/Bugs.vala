public class Vamp.Bugs : GLib.Object {
    public string url { get; set; }
    public string email { get; set; }

    public static Bugs from_json (Json.Node node) {
        assert (node.get_node_type () == Json.NodeType.OBJECT);
        return (Bugs) Json.gobject_deserialize (typeof (Bugs), node);
    }

    public Json.Node to_json () {
        return Json.gobject_serialize (this);
    }

    public bool equal (Vamp.Bugs other) {
        return this.url == other.url
            && this.email == other.email;
    }
}
