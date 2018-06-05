### Info

This directory contains
the batch file constructing the Javascript
executed on [mshta.exe](https://technet.microsoft.com/en-us/library/ee692768.aspx) without showing a window and receive the results output redirected to console.

The script i question queries the groupId, artifactId and version from the Maven project file on Windows platform via
XML DOM node processing without writing temporary files.

Running the script produces:
```cmd
example.cmd

groupId=com.github.sergueik.swet
artifactId=swet
version=0.0.9-SNAPSHOT
```
This could be used in batch files wrapping maven to build and launch projects.

There turns out to be a number of challengs implementing such a simple task.
The initial curious project [calc_date_embedded.cmd](https://github.com/gregzakh/notes/commit/7ad26f7d86996e66823c1c52a79289cc02137a60#diff-cbc7d950b3d9a90762d5544e0ffa5bcd)
shows how to concatenates the argument into command line representing a valid JS code fragment
into the script executed on mshta.exe and get the results output redirected to console

Note: the equivalent [VBScript example](https://stackoverflow.com/questions/28134997/can-i-run-vbscript-commands-directly-from-the-command-line-i-e-without-a-vbs-f?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa)
is somewhat harder to modify. Traditionally [mshta scripts](http://www.robvanderwoude.com/htaexamples.php) are using VbScript.

Then we use MS JScript engine [XML DOM API](https://msdn.microsoft.com/en-us/library/ms759095(v=vs.85).aspx)
to process the local XML file.
Currently we do not access the file  directly with __Msxml2.DOMDocument.6.0__
but first [read its  contents](https://www.powerobjects.com/2008/09/02/69/) with the help of __Scripting.FileSystemObject__.
and invoke the appropriate static constructor.

Another limitaion is the script size. It was found through experiment that
`mshta.exe` fails silently when inline script exceeds certain size: 495 chars is OK, but 519 chars is not OK
Therefore to make some node logic  possible the script developer is forced to
save on language syntax (dropping var declaration  and use single-character variable names etc.)
and whitespace, and this seriosly sacrifices redability of the script:

```javascript
javascript: {
  var fso = new ActiveXObject('Scripting.FileSystemObject');
  var stdout = fso.GetStandardStream(1);
  var fh = fso.OpenTextFile('pom.xml', 1, true);
  var xmlDoc = new ActiveXObject('Msxml2.DOMDocument.6.0');
  xmlDoc.async = false;
  fileData = fh.ReadAll();
  xmlDoc.loadXML(fileData);
  root = xmlDoc.documentElement;
  stdout.Write('Number of nodes: ' + root.childNodes.length + '\n');
  var nodes = root.childNodes;
  var tag = '%~1';
  for (i = 0; i != nodes.length; i++) {
    if (nodes.item(i).nodeName.match(RegExp(tag, 'g'))) {
      stdout.Write(tag + '=' + nodes.item(i).text + '\n');
      stdout.Write(node.xml + '\n');
      node = root.childNodes.item(3);
      stdout.Write(node.nodeName + '\n');
    }
  }
}
"

```
would become
```cmd
javascript:{
f=new ActiveXObject('Scripting.FileSystemObject');
c=f.GetStandardStream(1);
h=f.OpenTextFile('pom.xml', 1, 1);
x=new ActiveXObject('Msxml2.DOMDocument.6.0');
x.async=false;
x.loadXML(h.ReadAll());
r=x.documentElement;
t='%~1';
n=r.childNodes;
for(i=0;i!=n.length;i++){
if (n.item(i).nodeName.match(RegExp(t, 'g'))) {
c.Write(t+'='+n.item(i).text+'\n');
}
}
close();}"
```

### License
This project is licensed under the terms of the MIT license.

### Author
[Serguei Kouzmine](kouzmine_serguei@yahoo.com)
