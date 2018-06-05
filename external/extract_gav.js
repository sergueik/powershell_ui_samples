// based on https://msdn.microsoft.com/en-us/library/ms759095(v=vs.85).aspx
var xmlDoc = new ActiveXObject('Msxml2.DOMDocument.3.0');
var root;
xmlDoc.async = false;
xmlDoc.load('pom.xml');


if (xmlDoc.parseError.errorCode != 0) {
   var myErr = xmlDoc.parseError;
   WScript.Echo('You have error ' + myErr.reason);
} else {
  root = xmlDoc.documentElement;
  var tags = ['groupId','artifactId','version']
  for (var cnt in tags ) { 
    var tag = tags[cnt];
    var nodeList = root.selectNodes('/project/' + tag );
    for (var i = 0; i < nodeList.length; i++) {
      WScript.Echo(tag + ' = ' + root.childNodes.item(i).childNodes.item(0).text);
    }
  }
  
    for (var i = 0; i < nodeList.length; i++) {
      WScript.Echo(tag + ' = ' + root.childNodes.item(i).childNodes.item(0).text);
    }

var xmlnode = root.childNodes.item(1);
WScript.Echo(xmlnode.text + '\n');
WScript.Echo('item 1:\n' + xmlnode.xml + '\n');
var xmlnode = xmlDoc.documentElement.childNodes.item(2);
WScript.Echo('item 2:\n' + xmlnode.nodeName + '\n');
var xmlnode = xmlDoc.documentElement.childNodes.item(3);
WScript.Echo('item 3:\n' +xmlnode.text + '\n');

}
