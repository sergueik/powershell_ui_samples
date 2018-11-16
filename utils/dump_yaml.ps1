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

# based on library
# https://github.com/aaubry/YamlDotNet
# the stable package https://www.nuget.org/packages/YamlDotNet/5.0.0
# one can build YamlDotNet.Core.dll and YamlDotNet.RepresentationModel.dll standalone from source or load both clases from YamlDotNet.dll

# one can alsway compile from the source:
# git clone
# pushd
# path=%path%;n Source;c:\Windows\Microsoft.NET\Framework\v4.0.30319
# pushd YamlDotNet.Core &&  msbuild && popd
# pushd Dumper &&  msbuild && popd

# NOTE: does not work well with stacked Powershell shell instances launched

<#
.SYNOPSIS
	Deserialize the DTO of a provided YAML resource
.DESCRIPTION
	Passes the YAML resource path to construct the DTO and stops at first error printing the exception
	
.EXAMPLE

  dump_yaml -filename file.yaml [-verbosely]
  dump_yaml file.yaml
  get-item -path '*.yaml' | select-object -expandproperty fullname | dump_yaml
  get-childitem -include '*.yaml' -recurse | dump_yaml -verbosely

  in the non-verbose run, the script only shows the exceptions from the parser.
  Example exceptions in the constructor event propagation from YamlMappingNode class:
  
    Exception calling "Load" with "1" argument(s): 
    (Lin: 11, Col: 2, Chr: 179) - (Lin: 11, Col: 12, Chr: 189): Duplicate key
    (Lin: 14, Col: 15, Chr: 291) - (Lin: 46, Col: 0, Chr: 852): While scanning a quoted scalar, find unexpected end of stream.
    (Lin: 1, Col: 8, Chr: 14) - (Lin: 1, Col: 8, Chr: 14): Mapping values are not allowed in this context.
  
.LINK
	
.NOTES
  You now have to source the script before the functionality is available
  . .\utils\dump_yaml.ps1

	VERSION HISTORY
	2016/01/24 Initial Version
#>

function dump_yaml {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
    [string]$fileName,
    # NOTE adding pipeline parameter annotations revealed problem with parameter choice
    # https://stackoverflow.com/questions/10536282/powershell-defining-the-verbose-switch-in-a-function
    # A parameter with the name 'Verbose' was defined multiple times for the command.
    # the 'verbose' is one of Powershell v 2 reserved parameters, and later versions of Powershell are apparently also trying to protect
    [Parameter(Mandatory = $false,ValueFromPipeline = $false,ValueFromPipelineByPropertyName = $false)]
    [switch]$verbosely,
    [switch]$cleanSession # does not work if winrm is turned off
  )
  begin {

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

    function load_shared_assemblies {
      param(
        [string]$shared_assemblies_path = "c:\Users\${env:USERNAME}\Downloads",
        # NOTE: the $env:USERPROFILE - may likely be pointing to a mounted shared drive which will slow down loading of the assemblies
        [string[]]$shared_assemblies = @(
          'YamlDotNet.dll' # '5.0.0'
          # 'YamlDotNet.Core.dll' # '2.0.1'
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

    load_shared_assemblies
    # NOTE: to debug  custom built version of yaml assembly, may load it from local directory by overriding the shared_assemblies_path argument
    # -shared_assemblies_path ( Get-ScriptDirectory)
  }
  process {
    [bool]$verbose_flag = [bool]$PSBoundParameters['verbosely'].IsPresent

    [bool]$clean_session_flag = [bool]$PSBoundParameters['cleanSession'].IsPresent
    # need to exit pssession to unload YamlDotNet.dll. Really ?!
    # https://stackoverflow.com/questions/1337961/powershell-unload-module-completely
    if ($clean_session_flag) {
      Write-Debug 'Enter PS Session'
      Enter-PSSession -ComputerName '.'
      # enter-PSSession : Connecting to remote server localhost failed with the
      # following error message : WinRM cannot process the request. The following
      # error with errorcode 0x8009030e occurred while using Negotiate authentication
      Enter-PSSession
    }

    $filePath = Resolve-Path -Path $fileName
    Write-Host -foregroundcolor 'DarkGray'  $filePath
    [string]$data = (Get-Content -Path $filePath) -join "`n"
    [System.IO.TextReader]$inputFile = [System.IO.File]::OpenText($filePath)
    # NOTE: cannot assign automatic variable 'input' with type 'System.Object'
    try {

      [YamlDotNet.Core.PArser]$parser = New-Object YamlDotNet.Core.Parser ($inputFile)
      try {
        # NOTE: the following code will only work with patched dll, 
        # which Parser class has the 'AlowDuplicates' property
        $parser.AlowDuplicates = $false
      } catch [exception]{
      }
      $indent = 0
      while ($parser.MoveNext()) {
        # NOTE: incorrect way of coverting 'is'
        <#
    if (( $parser.Current -eq [YamlDotNet.Core.Events.StreamEnd]) -or
        ( $parser.Current -eq [YamlDotNet.Core.Events.DocumentEnd]) -or
        ( $parser.Current -eq [YamlDotNet.Core.Events.SequenceEnd]) -or
        ( $parser.Current -eq [YamlDotNet.Core.Events.MappingEnd]))) {
    #>
        # NOTE: another incorrect way of coverting 'is'
        <#
    if (( $parser.Current -eq (new-object YamlDotNet.Core.Events.StreamEnd)) -or
        ( $parser.Current -eq (new-object YamlDotNet.Core.Events.DocumentEnd($false) )) -or
        ( $parser.Current -eq (new-object YamlDotNet.Core.Events.SequenceEnd)) -or
        ( $parser.Current -eq (new-object YamlDotNet.Core.Events.MappingEnd))) {
    #>
        if ($parser.Current.ToString() -match '(?:Stream end|Document end|Sequence end|Mapping end)') {
          # indent but do not print the occurence of those event
          $indent = $indent - 1
        }
        elseif ($parser.Current.ToString() -match '(?:Stream start|Document start|Sequence start|Mapping start)') {
          $indent = $indent + 1
        } else {
          $output = ''
          for ($i = 0; $i -le $indent; $i++) {
            $output += ' '
          }
          if ($verbose_flag) {
            # invoke ToString() method of the current Scalar event
            Write-Output ('{0}{1}' -f $output,$parser.Current.ToString())
          }
        }
      }
    } catch [exception]{
      # TODO: integrate custom_msgbox maybe
      # $action = show_exception -ex $_.Exception
      # if ($action -ne 'Ignore') {
      #  throw $_.Exception
      # }
      Write-Error ("Unexpected exception {0}`n{1}" -f ($_.Exception.GetType()),($_.Exception.Message))
    } finally {
      if ($clean_session_flag) {
        Write-Debug 'Exit PS Session'
        Exit-PSSession
      }
    }
  }
}
