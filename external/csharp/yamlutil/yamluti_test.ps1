param (
  [String]$assembly_path = './Utility/bin/Debug',
  [String]$datafile = 'sampledata.yaml'
)
<#
if ($env:PROCESSOR_ARCHITECTURE -ne 'x86') {
  # if the dll is compiled in SharpDevelop for x86 (e.g. for debugging)
  # attempt to load in 64 bit Powershell will fail with "BadImageFormatException"
  write-output 'this test needs to be run on c:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe'
  exit 1;
}
#>
$asssembly = 'YamlUtility.dll'
$shared_assemblies = @($asssembly)
pushd $assembly_path

add-type -path $shared_assemblies[0]
$asssembly_version = ((get-item -path $asssembly | select-object -expandproperty VersionInfo).ProductVersion ) -replace '\..*$', ''
write-output ('Running with assembly version {0}' -f $asssembly_version)
popd

$o = new-object QiHe.Yaml.Grammar.YamlParser
$text = @'
---
a: b
'@
$text = (Get-Content -Path ([System.IO.Path]::Combine((get-location),$datafile)) -ErrorAction 'silentlycontinue') -join "`r`n"
write-output $text
$input = new-object  QiHe.Yaml.Grammar.TextInput($text)
[bool]$status = $false
# NOTE 'out' argument error
# Argument: '2' should be a System.Management.Automation.PSReference. Use [ref].
[QiHe.Yaml.Grammar.YamlStream]$result = $o.ParseYamlStream($input,[ref]$status)
# write-output $result.getType()|select-object -property *
write-output ('result type: {0}' -f $result.getType().FullName)
[QiHe.Yaml.Grammar.YamlDocument[]]$documents = $result.Documents
<#
try {
  $documents | get-member
  # NOTE: will not intercept the failed run
} catch [NoObjectInGetMember] {

}
#>
write-output ('documents type: {0}' -f $documents.get(0).getType().FullName)
$root =  $documents.get(0).Root
write-output ('root type: {0}' -f $root.getType().FullName)
# write-output $root|get-member
# further is datafile specific
# NOTE: typo in the original class code
# Mapping.cs: public List<MappingEntry> Enties = new List<MappingEntry>();

$root_enties = $root.Enties
# $root_enties | get-member
write-output ('enties type: {0}' -f $root_enties.getType().FullName)
function process_enties {
  param(
    # TODO: type
    $enties

  )
  write-output ('processing {0} enties' -f $enties.Count)
  if ($enties.count -eq 0) {
    return
  }
  $cnt = 0
  $enties| foreach-object {
    write-output('entry # {0}' -f $cnt )
    $cnt ++
    $_entry = $_
    # $_entry | get-member
    $_key = $_entry.key
    write-output ('processing key {0}' -f $_key)
    $enties1 = $_entry.enties
    write-output ('processing enties {0}' -f $enties1)
    write-output 'Calling resursively'
    process_enties -enties $enties1
    $_value = $_entry.value
    if ($_value -eq $null) {
      return
    }
    $_t =  $_value.getType().Name
    write-output ('processing type {0}' -f $_t)
    if ($_t -eq 'Scalar') {
      write-output ('Key: {0} Value: {1} ({2})' -f $_key.text, $_value.Text, $_t )
    }
    if ($_t -eq 'Sequence') {
      $_enties2 = $_value.Enties
      write-output ('Key {0} Enties: {1} ({2})' -f $_key.Text, $_enties2, $_t)
        write-output 'Calling resursively'
        process_enties -enties $_enties2
    }

  }
}
$root_enties| foreach-object {
  $entry = $_
  $key = $entry.key
  $value = $entry.value
  $t =  $value.getType().Name
  if ($t -eq 'Scalar') {
    write-output ('Key: {0} Value: {1} ({2})' -f $key.text, $value.Text, $t )
  }
  if ($t -eq 'Sequence') {
    $enties2 = $element.Enties
    write-output ('Key {0} Enties: {1} ({2})' -f $key.Text, $enties2, $t)
  }

}
process_enties -enties $root_enties
