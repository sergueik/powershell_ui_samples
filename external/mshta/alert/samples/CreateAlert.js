var myTypeLib = new ActiveXObject("Scriptlet.Typelib");
var GUID = new String(myTypeLib.guid).substr(0,38);
var szFileName="c:\\MyAlerts\\queue\\" + GUID + ".txt"
var fso = new ActiveXObject("Scripting.FileSystemObject")
var tf = fso.CreateTextFile(szFileName, true);
tf.WriteLine("Hello Microsoft|http://www.microsoft.com|en-UK_female");
tf.Close();
