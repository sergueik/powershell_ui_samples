# origin: https://4sysops.com/archives/convert-json-to-a-powershell-hash-table/
# does not work

function ConvertTo-Hashtable {
    [CmdletBinding()]
    [OutputType('hashtable')]
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )

    process {
        ## Return null if the input is null. This can happen when calling the function
        ## recursively and a property is null
        if ($null -eq $InputObject) {
            return $null
        }

        ## Check if the input is an array or collection. If so, we also need to convert
        ## those types into hash tables as well. This function will convert all child
        ## objects into hash tables (if applicable)
        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
            $collection = @(
                foreach ($object in $InputObject) {
                    ConvertTo-Hashtable -InputObject $object
                }
            )

            ## Return the array but don't enumerate it because the object may be pretty complex
            Write-Output -NoEnumerate $collection
        } elseif ($InputObject -is [psobject]) { ## If the object has properties that need enumeration
            ## Convert it to its own hash table and return it
            $hash = @{}
            foreach ($property in $InputObject.PSObject.Properties) {
                $hash[$property.Name] = ConvertTo-Hashtable -InputObject $property.Value
            }
            $hash
        } else {
            ## If the object isn't an array, collection, or other object, it's already a hash table
            ## So just return it.
            $InputObject
        }
    }
}

$data_json = @'
{
  "Apples": {
     "red":10,
     "green":1
   },
  "Pears": {
    "yellow": 1
   }
}
'@

# This does not work with nested JSON
<#

$data = @{}
foreach ($property in ($data_json| ConvertFrom-Json ).PSObject.Properties) {
    $data.add($property.Name,$property.Value)
}
#>
$data = $data_json | ConvertFrom-Json | ConvertTo-HashTable

# column separator
$s = "`t"
$s = '|'
$data.keys | foreach-object {
  $data_key = $_
  $data_row = $data[$data_key]
  write-output "${data_key}${s}${s}"
  $data_row.keys | foreach-object {
    $row_key = $_
    $row_value = $data_row.$row_key
    # NOTE: the following does not work
    # $row_value = $data_row_hash[$row_key]
    write-output "${s}${row_key}${s}${row_value}"
}

<#
$data_row_hash = @{}
foreach ($property in $data_row.PSObject.Properties) {
write-output $property.Name
    $data_row_hash[$property.Name] = $property.Value
}
  $data_row_hash.keys | foreach-object {

    $row_key = $_
    $row_value = $data_row_hash[$row_key]
    write-output "${s}${row_key}${s}${row_value}"


  }
#>
}

