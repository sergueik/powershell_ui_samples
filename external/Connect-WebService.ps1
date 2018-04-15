# based on: http://www.leeholmes.com/blog/2007/02/28/calling-a-webservice-from-powershell/
# cmdlet
param(
  [string]$serviceURL = $(throw "Please specify a WSDL service url"),
  [string]$namespace,
  [switch]$requiresAuthentication)

## Create the web service cache, if it doesn't already exist
if (-not (Test-Path Variable:\example.WebServiceCache)) {
  ${GLOBAL:example.WebServiceCache} = @{}
}

## Check if there was cached instance and return that instead

$cachedInstance = ${GLOBAL:example.WebServiceCache}[$serviceURL]
if ($cachedInstance) {
  return $cachedInstance
}


[void][Reflection.Assembly]::LoadWithPartialName('System.Web.Services')

## Download the requested service WSDL, and generate service description
$wc = new-object -typeName 'System.Net.WebClient'

if ($requiresAuthentication) {
  $wc.UseDefaultCredentials = $true
}

$wsdlStream = $wc.OpenRead($serviceURL)

## Ensure that we were able to fetch the WSDL

if (-not (Test-Path Variable:\wsdlStream)) {
  return $null
}

$serviceDescription = [Web.Services.Description.ServiceDescription]::Read($wsdlStream)

$wsdlStream.Close()

## Ensure that we were able to read the WSDL into a service description
if (-not (Test-Path Variable:\serviceDescription)) {
  return $null
}

## Import the web service into a CodeDom
$serviceNamespace = new-object -TypeName 'System.CodeDom.CodeNamespace'

if ($namespace) {
  $serviceNamespace.Name = $namespace
}
$codeCompileUnit = new-object -TypeName 'System.CodeDom.CodeCompileUnit'
$serviceDescriptionImporter = new-object -TypeName 'Web.Services.Description.ServiceDescriptionImporter'
$serviceDescriptionImporter.AddServiceDescription($serviceDescription,$null,$null)

[void]$codeCompileUnit.Namespaces.Add($serviceNamespace)
[void]$serviceDescriptionImporter.Import($serviceNamespace,$codeCompileUnit)

## Generate the code from that CodeDom into a string
$generatedCode = new-object -TypeName 'Text.StringBuilder'
$stringWriter = new-object -TypeName 'IO.StringWriter' $generatedCode
$provider = new-object -TypeName 'Microsoft.CSharp.CSharpCodeProvider'
$provider.GenerateCodeFromCompileUnit($codeCompileUnit,$stringWriter,$null)

## Compile the source code.

$references = @( 'System.dll','System.Web.Services.dll','System.Xml.dll')
$compilerParameters = new-object -TypeName 'System.CodeDom.Compiler.CompilerParameters'
$compilerParameters.ReferencedAssemblies.AddRange($references)
$compilerParameters.GenerateInMemory = $true

$compilerResults = $provider.CompileAssemblyFromSource($compilerParameters,$generatedCode)
if ($compilerResults.Errors.Count -gt 0) {
  $errorLines = ''
  foreach ($error in $compilerResults.Errors) {
    $errorLines += "`n`t" + $error.'Line' + ":`t" + $error.'ErrorText'
  }
  Write-Error $errorLines
  return $null
}

## Create the webservice object and return it.
## Get the assembly that we just compiled

$assembly = $compilerResults.CompiledAssembly

## Find the type of interst by its assigned `WebServiceBindingAttribute`

$type = $assembly.GetTypes() | where-object { $_.GetCustomAttributes([System.Web.Services.WebServiceBindingAttribute],$false) }
if (-not $type) {
  write-error 'Could not generate web service proxy.'
  return $null
}

## Create, cache and return an instance of the type

$instance = $assembly.CreateInstance($type)
${GLOBAL:example.WebServiceCache}[$serviceURL] = $instance

return $instance

<#

## Example:
## for the list of piublicly available soap services see
http://quicksoftwaretesting.com/sample-wsdl-urls-testing-soapui/
## see also
http://sencs.blogspot.com/2014/12/list-of-publicly-available-web-services.html
https://msdn.microsoft.com/en-us/library/windows/desktop/ee354195(v=vs.85).aspx
   $wsdl = 'http://ws.cdyne.com/ip2geo/ip2geo.asmx?wsdl'
   $ip2geoServer = ./Connect-WebService.ps1 $wsdl
   $ipAddress = '73.139.20.178'
   $licenseKey = $null
   $geoFacts = $ip2geoServer.ResolveIP($ipAddress, $licenseKey)
   $geoFacts

#>
<#
City               : Pompano Beach
StateProvince      : FL
Country            : United States
Organization       :
Latitude           : 26.2379
Longitude          : -80.1248
AreaCode           : 954
TimeZone           :
HasDaylightSavings : False
Certainty          : 90
RegionName         :
CountryCode        : US
#>

