# based on: https://github.com/rgl/ValidateSchema
# this code only accepts XML schema documents, not generic XML
# example XML schema document from https://msdn.microsoft.com/en-us/library/ms256129(v=vs.110).aspx

add-type -TypeDefinition @"

using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Schema;

public class SchemaValidator {

    private string[] paths = null;  
    public SchemaValidator() {
    
    }
  public int Validate(string[] args)
  {
	  if (args.Length == 0)
	  {
		  Console.WriteLine("Usage: ValidataSchema <XML_SCHEMA_FILE_PATH>");
		  return 127;
	  }

	  var results = new List<ValidationEventArgs>();

	  var schemaSet = new XmlSchemaSet();

	  schemaSet.ValidationEventHandler += (sender, a) => results.Add(a);

	  foreach (var path in args) {
		  schemaSet.Add(null, path);
	  }

	  schemaSet.Compile();

	  foreach (var result in results.OrderBy(r => r.Exception.SourceUri).ThenBy(r => r.Exception.LineNumber).ThenBy(r => r.Exception.LinePosition))
	  {
		  Console.Error.WriteLine(
			  "{0} ({1}:{2}): {3}: {4}",
			  result.Exception.SourceUri,
			  result.Exception.LineNumber,
			  result.Exception.LinePosition,
			  result.Severity,
			  result.Message
		  );
	  }

	  return results.Count == 0 ? 0 : 1;
  }
}
"@ -ReferencedAssemblies 'System.dll','System.Data.dll','System.Data.Linq.dll', 'System.Xml.dll'
[string]$xml_path = Resolve-Path 'schema_example.xml'
Write-Host ('Probing "{0}"' -f $xml_path)
$caller = New-Object SchemaValidator -ArgumentList @()
$caller.validate(@($xml_path))
