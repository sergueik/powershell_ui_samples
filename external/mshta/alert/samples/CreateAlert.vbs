Set myTypeLib = CreateObject("Scriptlet.Typelib")
GUID = left(trim(myTypeLib.guid),38)
szFileName="c:\MyAlerts\queue\" & GUID & ".txt"
Set fso = CreateObject("Scripting.FileSystemObject")
Set tf = fso.CreateTextFile(szFileName, True)
tf.WriteLine("Hello Microsoft|http://www.microsoft.com|en-UK_female") 
tf.Close
