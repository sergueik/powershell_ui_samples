// based on https://msdn.microsoft.com/en-us/library/ms759095(v=vs.85).aspx

var xmlDoc = new ActiveXObject('Msxml2.DOMDocument.3.0');
var root;
xmlDoc.async = false;
xmlDoc.load('pom.xml');


if (xmlDoc.parseError.errorCode != 0) {
    var e = xmlDoc.parseError;
    WScript.Echo('Error parsing error ' + e.reason);
} else {
    WScript.Echo('Using selectSingleNode');
    root = xmlDoc.documentElement;
    var xpaths = ['/groupId', '/artifactId', '/version', '/properties/mainClass', '/properties/skdf_jprotractor.version']
    for (var cnt in xpaths) {
        var xpath = '/project' + xpaths[cnt];
        var xmlnode = root.selectSingleNode(xpath);
        if (xmlnode != null) {
          WScript.Echo(xpaths[cnt] + ' = ' + xmlnode.text);
        } else {
          WScript.Echo('Nothing dfound for: '+ xpaths[cnt]);
        }
    }
    // Maven project target g.a.v. is in the immediate children of the project
    WScript.Echo('Browsing childNodes');
    var tags = ['groupId', 'artifactId', 'version']
    var nodelist = root.childNodes;
    for (var i = 0; i != nodelist.length; i++) {
        var xmlnode = nodelist.item(i);
        for (var cnt in tags) {
            var tag = tags[cnt];
            if (xmlnode.nodeName.match(RegExp(tag, 'g'))) {
                WScript.Echo(tag + ' = ' + xmlnode.text + '\n' + xmlnode.xml);
            }
        }
    }
    // TODO: use querySelector
}