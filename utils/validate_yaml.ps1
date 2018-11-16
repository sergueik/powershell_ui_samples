#Copyright (c) 2016,2018 Serguei Kouzmine
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

# origin: https://github.com/scottmuc/PowerYaml
# based on lobrary
# https://github.com/aaubry/YamlDotNet
# the stable package https://www.nuget.org/packages/YamlDotNet/5.0.0
# one can build YamlDotNet.Core.dll and YamlDotNet.RepresentationModel.dll standalone from source or load both clases from YamlDotNet.dll

<#
.SYNOPSIS
	Deserialize the DTO of a provided YAML resource
.DESCRIPTION
	Passes the YAML resource path to construct the DTO and stops at first error printing the exception
	
.EXAMPLE

  Example exception in the condtructor event propagation from YamlMappingNode class:
  Exception calling "Load" with "1" argument(s): "(Lin: 11, Col: 2, Chr: 179) - (Lin: 11, Col: 12, Chr: 189): Duplicate key"
	
.LINK
	
.NOTES
	VERSION HISTORY
	2016/01/24 Initial Version
#>

function validate_yaml {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
    [string]$fileName
  )
  begin {

    function get-YamlStreamFromString {
      param(
        [string]$data
      )
      $sr = New-Object System.IO.StringReader ($data)
      $o = New-Object YamlDotNet.RepresentationModel.YamlStream
      $o.Load([System.IO.TextReader]$sr)
      return $o
    }

    function Get-YamlStreamFromFile {
      param([string]$filePath)
      $text = [System.IO.File]::OpenText($filePath)
      $YRM_obj = New-Object YamlDotNet.RepresentationModel.YamlStream
      $YRM_obj.Load([System.IO.TextReader]$text)
      $text.Close()
      return $YRM_obj
    }

    # NOTE: does not work well with stacked Powershell shell instances launched
    function Get-ScriptDirectory {
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

    function OpenLog {
      param(
        [string]$filePath
      )
      $data = (Get-Content -Path $filePath) -join "`n"
      $yaml = get-YamlStreamFromString $data
      return $yaml
    }

    function load_shared_assemblies {
      param(
        [string]$shared_assemblies_path = "c:\Users\${env:USERNAME}\Downloads",
        # NOTE: the $env:USERPROFILE - may likely be pointing to a mounted shared drive which will slow down loading of the assemblies
        [string[]]$shared_assemblies = @(
          'YamlDotNet.dll' # '5.0.0'
          # custom build:
          # 'YamlDotNet.Core.dll',# '2.0.1'
          # 'YamlDotNet.RepresentationModel.dll' # '2.0.1'
          # 'nunit.core.dll' # '3.0.0-beta-4'
          # 'nunit.framework.dll' # TODO - check if still needed
        )
      )

      pushd $shared_assemblies_path

      $shared_assemblies | ForEach-Object {
        Unblock-File -Path $_
        if ($DebugPreference -eq 'Continue') {
          write-host -foregroundcolor 'Cyan' $_
        }
        Add-Type -Path $_
      }
      popd
    }
    load_shared_assemblies # -shared_assemblies_path ( Get-ScriptDirectory)
  }
  process {
    [bool]$verbose_flag = [bool]$PSBoundParameters['verbosely'].IsPresent
    $filePath = Resolve-Path -Path $fileName
    Write-Host -ForegroundColor 'DarkGray' $filePath
    $yaml_obj = openLog -FilePath $filePath
    if ($DebugPreference -eq 'Continue') {
      $yaml_obj | get-member
    }
    $bad_elements = @()
    # custom validation
    $bad_elements += ($yaml_obj.AllNodes | select-object -property value | where-object { ($_.Value -match ' $') -or ($_.Value -match '^ ') })
    if ($bad_elements.size -ne 0 -and $bad_elements.size -ne $null) {
      throw (('Bad format elements (total of {0})' -f $bad_elements.size) + [string]::Join(',',$bad_elements))
    }
  }
}
