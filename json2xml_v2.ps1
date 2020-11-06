# https://www.cyberforum.ru/powershell/thread2724372.html
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
<#
foreach ($item in $json_obj) {
  $result[$item] = $json_obj.$item
}
#>
$json_obj | get-member -MemberType NoteProperty | foreach-object {
  $name = $_.Name
  $result[$name] = $json_obj."$(${name})"
}
if ($debug){
  $result | format-list
}
$cnt = 0
$settings = new-object System.Xml.XmlWriterSettings
$settings.indent = $true
$settings.indentchars = "`t"
$xml = [System.Xml.XmlWriter]::create([System.IO.Path]::Combine($scriptDirectory, $output_file), $settings)
$xml.writestartdocument()
$xml.writestartelement($root_element)
$result.Keys | foreach-object {
  $key = $_
  $value = $result[$key]
  if ($debug) {
    $cnt ++
    $xml.WriteStartElement($key)
    $xml.WriteAttributeString('index', $cnt)
    $xml.WriteValue($value)
    $xml.WriteEndElement()

  } else {
    $xml.WriteElementString($key,$value)
  }
}
$xml.writeendelement() 
$xml.writeenddocument()
$xml.flush()
$xml.close()
write-output ('Done: {0}' -f $output_file)
