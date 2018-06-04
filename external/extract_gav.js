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
}
