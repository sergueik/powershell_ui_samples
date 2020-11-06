# based on: https://petri.com/creating-custom-xml-net-powershell

param(
  [String]$input_file = 'example.json',
  [String]$output_file = 'custom.xml',
  [String]$root_element = 'data',
  [switch]$debug
)
$scriptDirectory = (get-variable PSScriptRoot).value
$data = (get-content -Path ([System.IO.Path]::Combine($scriptDirectory, $input_file))) -join "`n"

$json_obj = convertfrom-json -InputObject $data
$result = @{}

# https://stackoverflow.com/questions/18779762/iterating-through-key-names-from-a-pscustomobject?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
# Convert the PSCustomObject back to a hashtable
$json_obj | get-member -MemberType NoteProperty | foreach-object {
  $name = $_.Name
<#
  # if deeper
  $result[$name] = @{}
  $data = $json_obj."$($_.Name)"
  $data_hash_obj = @{}
  $data | Get-Member -MemberType NoteProperty | ForEach-Object {
    $key = $_.Name
    $value = $data."$(${key})"
    $data_hash_obj[$key] = $value
  }
  $result[$name] = $data_hash_obj
#>
  $result[$name] = $json_obj."$(${name})"
}


$cnt = 0 
[xml]$Doc = new-object System.Xml.XmlDocument
$declaration = $Doc.CreateXmlDeclaration('1.0', 'UTF-8', $null)
$doc.AppendChild($declaration)
$root = $doc.CreateNode('element', $root_element, $null)
$result.Keys  | foreach-object {
  $key = $_
  $value = $result[$key]
  $node = $doc.CreateNode('element', $key, $null)
  $text = $doc.CreateTextNode($value)
  $node.appendChild($text)
  if ($debug) {
    $cnt ++
    $node.SetAttribute('index', $cnt)
  }
  $root.AppendChild($node)
}

$doc.AppendChild($root) | out-null
$doc.save(([System.IO.Path]::Combine($scriptDirectory, $output_file)) )
write-output ('Done: {0}' -f $output_file)
