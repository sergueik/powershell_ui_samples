#Copyright (c) 2018 Serguei Kouzmine
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

param(
  [String]$filePath
)

# https://github.com/aaubry/YamlDotNet
# http://stackoverflow.com/questions/14894864/how-to-download-a-nuget-package-without-nuget-exe-or-visual-studio-extension
# http://www.nuget.org/api/v2/package/<assembly>/<version>


# NOTE: does not work well with stacked Powershell shell instances launched
function Get-ScriptDirectory{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  if ($Invocation.PSScriptRoot) {
    $Invocation.PSScriptRoot
  }
  elseif ($Invocation.MyCommand.Path) {
    Split-Path $Invocation.MyCommand.Path
  } else {
    $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf(''))
  }
}


function load_shared_assemblies {
  param(
    [String]$shared_assemblies_path = "${env:USERPROFILE}\Downloads",
    [string[]]$shared_assemblies = @(
    'YamlDotNet.Core.dll' # '2.0.1'
    # 'nunit.core.dll' # '3.0.0-beta-4'
    # 'nunit.framework.dll' # TODO - check if still needed
    )

  )

  pushd $shared_assemblies_path

  $shared_assemblies | ForEach-Object {
    Unblock-File -Path $_
    # Write-Host -foregroundcolor 'Cyan' $_
    Add-Type -Path $_
  }
  popd
}

<#
.SYNOPSIS
	Deserialize the DTO of a provided YAML resource
.DESCRIPTION
	Passes the YAML resource path to construct the DTO and stops at first error printing the exception
	
.EXAMPLE
	
.LINK
	
.NOTES
	VERSION HISTORY
	2016/01/24 Initial Version
#>
load_shared_assemblies -shared_assemblies_path (get-scriptdirectory)
[String]$data = (Get-Content -Path $filePath) -join "`n"
[System.IO.TextReader] $input = [System.IO.File]::OpenText($filePath)
try {

  [YamlDotNet.Core.PArser]$parser = new-object YamlDotNet.Core.Parser($input)
  # will only work with patched dll
  try {
    $parser.AlowDuplicates = $false
  } catch [Exception]{
  }
  $indent = 0
  while ($parser.MoveNext()) {
    # TODO: covert 'is'
    if ( ( $parser.Current.toString() -match '(?:Stream end|Document end|Sequence end|Mapping end)') -or
        ( $parser.Current -eq [YamlDotNet.Core.Events.MappingEnd]) -or
        ( $parser.Current -eq (new-object YamlDotNet.Core.Events.StreamEnd))) {
    $indent = $indent - 1
    }
    elseif ($parser.Current.toString() -match '(?:Stream start|Document start|Sequence start|Mapping start)') {
      $indent = $indent + 1
    } else {
    $output  = ''
    for ($i = 0; $i -le $indent; $i++) {
      $output   += ' '
    }
    write-output ('{0}{1}' -f $output , $parser.Current.ToString())
    }
  }
} catch [Exception]{
  # TODO: integrate custom_msgbox maybe
  # $action = show_exception -ex $_.Exception
  # if ($action -ne 'Ignore') {
  #  throw $_.Exception
  # }
  write-error ("Unexpected exception {0}`n{1}" -f ( $_.Exception.GetType() ) , ( $_.Exception.Message) )
  <#
    Example exception in the condtructor event propagation from YamlMappingNode class:
    Exception calling "Load" with "1" argument(s): "(Lin: 11, Col: 2, Chr: 179) - (Lin: 11, Col: 12, Chr: 189): Duplicate key"
    (Lin: 14, Col: 15, Chr: 291) - (Lin: 46, Col: 0, Chr: 852): While scanning a quoted scalar, find unexpected end of stream.
    (Lin: 1, Col: 8, Chr: 14) - (Lin: 1, Col: 8, Chr: 14): Mapping values are not allowed in this context.
  #>
}

# need to exit pssession to unload YamlDotNet.dll. Really ?!
# https://stackoverflow.com/questions/1337961/powershell-unload-module-completely
