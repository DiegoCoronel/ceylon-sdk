import ceylon.html {
    Node,
    Html,
    Element,
    TextNode,
    blockTag,
    ParentNode,
    Snippet,
    emptyTag
}

shared class NodeSerializer(
    "A stream to direct output to"
    void print(String string),
    "Serialization options"
    SerializerConfig config = SerializerConfig()
) {

    variable value indentLevel = 0;

    variable value sizeCount = 0;

    value prettyPrint = config.prettyPrint;

    shared void serialize(Node root) => visit(root);

    shared Integer contentLength => sizeCount;

    void doPrint(String string) {
        sizeCount += string.size; // TODO accurate byte size?
        print(string);
    }

    void visitAny(Node|{Node*}|Snippet<Node> child) {
        if (is Node child) {
            visit(child);
        } else if (is {Node*} child) {
            visitNodes(child);
        } else if (exists content = child.content) {
            visitAny(content);
        }
    }
    
    void visit(Node node) {
        if (is Html node) {
            startHtml(node);
        }
        indent();
        openTag(node);
        if (is Element node) {
            visitElement(node);
        }
        endOpenTag(node);
        indentLevel++;
        if (is TextNode node, !node.text.trimmed.empty) {
            linefeed();
            indent();
            doPrint(node.text);
        }
        if (is ParentNode<Node> node) {
            for (child in node.children) {
                if (exists child) {
                    linefeed();
                    visitAny(child);
                }
            }
        }
        indentLevel--;
        if (node.tag.type == blockTag) {
            linefeed();
            indent();
            closeTag(node);
        }
    }

    void startHtml(Html html) {
        doPrint(html.doctype.string);
        linefeed(true);
        linefeed();
    }

    void visitElement(Element node) {
        printAttributes(node);
    }

    void openTag(Node node) => doPrint("<``node.tag.name``");

    void endOpenTag(Node node) {
        if (node.tag.type == emptyTag) {
            doPrint(" /");
        }
        doPrint(">");
    }

    void closeTag(Node node) => doPrint("</``node.tag.name``>");

    void printAttributes(Element node) {
        for (attrName->attrValue in node.attributes) {
            value val = attrValue.string.trimmed;
            if (!val.empty) {
                doPrint(" ``attrName``=\"``attrValue``\"");
            }
        }
    }

    void visitNodes({Node*} nodes) {
        for (node in nodes) {
            visit(node);
        }
    }

    void linefeed(Boolean force = false) {
        if (prettyPrint || force) {
            doPrint(operatingSystem.newline);
        }
    }

    void indent() {
        if (prettyPrint) {
            doPrint(indentString);
        }
    }

    String indentString {
        value spaces = indentLevel * 4;
        return spaces > 0 then " ".repeat(spaces) else "";
    }

}

"A [[NodeSerializer]] implementation that prints content on console."
shared NodeSerializer consoleSerializer = NodeSerializer(process.write);
