// based on https://msdn.microsoft.com/en-us/library/ms759095(v=vs.85).aspx
var xmlDoc = new ActiveXObject('Msxml2.DOMDocument.3.0');
var root;
xmlDoc.async = false;
xmlDoc.load('pom.xml');


if (xmlDoc.parseError.errorCode != 0) {
    var myErr = xmlDoc.parseError;
    WScript.Echo('You have error ' + myErr.reason);
} else {
    WScript.Echo('Pass 1.');
    root = xmlDoc.documentElement;
    var tags = ['groupId', 'artifactId', 'version']
    for (var cnt in tags) {
        var tag = tags[cnt];
        var xmlnode = root.selectSingleNode('/project/' + tag);
        if (xmlnode != null) {
          WScript.Echo(tag + ' = ' + xmlnode.text);
        }
    }
    // Maven project target g.a.v. is in the immediate children of the project
    WScript.Echo('Pass 2.');
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
}