add-type -typeDefinition @'

add-type -typeDefinition @'

using System;
using System.Collections.Generic;
using System.Text;
using System.Collections.ObjectModel;
using System.Runtime.InteropServices;
using System.IO;
using System.Xml.Serialization;
using System.Xml;



public class  Util {
public static string SerializerToXml()
{
string result = null;
SPV4664 data = new SPV4664();
XmlWriterSettings settings = new XmlWriterSettings();
  XmlSerializerNamespaces ns = new XmlSerializerNamespaces();
    ns.Add("xy", "http://service.siw.pktbcki.rzd/");
MemoryStream ms = new MemoryStream();
    XmlWriter sw  = XmlWriter.Create(ms, settings);
StreamReader sr = new StreamReader(ms) ;
        XmlSerializer xs = new XmlSerializer(data.GetType());
        
xs.Serialize(sw, data, ns);
ms.Position = 0;
result = sr.ReadToEnd();
    

    return result;
}

}

[System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.6.1590.0")]
[System.SerializableAttribute()]
[System.Diagnostics.DebuggerStepThroughAttribute()]
[System.ComponentModel.DesignerCategoryAttribute("code")]
[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://service.siw.pktbcki.rzd/")]
[System.Xml.Serialization.XmlRootAttribute(Namespace = "http://service.siw.pktbcki.rzd/", IsNullable = false)]
public partial class SPV4664
{

public String data;
    public String Data
    {
        get
        {
            return this.data;
        }
        set
        {
            this.data = value;
        }
    }

}
'@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Drawing.dll','System.Data.dll', 'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'

write-output ([Util]::SerializerToXml())
<#

<?xml version="1.0" encoding="utf-8"?>
<xy:SPV4664 xmlns:xy="http://service.siw.pktbcki.rzd/" />

#>
