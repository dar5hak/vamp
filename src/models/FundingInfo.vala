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

    public static Json.Node list_to_json (Gee.List<FundingInfo> list) {
        var node_array = new Json.Array.sized (list.size);

        list.foreach ((element) => {
            node_array.add_element (element.to_json ());
            return true;
        });

        var node = new Json.Node (Json.NodeType.ARRAY);
        node.set_array (node_array);
        return node;
    }

    public Json.Node to_json () {
        var obj = new Json.Object ();
        if (this.funding_type != null) {
            obj.set_string_member ("type", this.funding_type);
        }

        if (this.url != null) {
            obj.set_string_member ("url", this.url);
        }

        var result = new Json.Node (Json.NodeType.OBJECT);
        result.set_object (obj);

        return result;
    }

    public bool equal (Vamp.FundingInfo other) {
        return this.funding_type == other.funding_type
            && this.url == other.url;
    }
}
