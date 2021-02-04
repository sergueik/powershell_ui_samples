class VideoFile {
    $InputFileLiteralPath
    $OutFileLiteralPath
    $Arguments
}

function Measure-VideoLenght {
    param (
        $SourceVideoPath,
        $FfmpegPath
    )
    Set-Location $FfmpegPath 

    .\ffprobe.exe -sexagesimal -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 $SourceVideoPath | ForEach-Object { 
        return  $_
    }    
}

function Measure-VideoResolution {
    param (
        $SourceVideoPath,
        $FfmpegPath
    )
    Set-Location $FfmpegPath 

    .\ffprobe.exe -v error -select_streams v:0 -show_entries stream=height -of csv=s=x:p=0 $SourceVideoPath | ForEach-Object {
        return $_
    }
}

function Test-WriteAccess {
    param(
        $Path
    )
    try {
        "" | Out-File $Path -Append
        Remove-Item $Path
        return $true
    }
    catch {
        return $false
    }
}

function Test-OutputFolder {
    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [psobject]$InputObject
    )
    if (Test-Path (Split-Path $InputObject)) {
        return $true
    }
    else {
        return $false
    }
}

function Join-InputFileLiterallPath {
    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [psobject]$InputObject
    )
    $VideofileObject = [VideoFile]::new()
    $VideofileObject.InputFileLiteralPath = ([io.path]::GetFullPath($InputObject))
    $VideofileObject.Arguments = " -i " + '"' + $([io.path]::GetFullPath($InputObject)) + '"'

    return $VideofileObject
}

function Join-Preset {
    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [psobject]$InputObject,
        [string]$Preset
    )
    $InputObject.Arguments += " -preset " + $Preset
    return $InputObject 
}

function Join-ConstantRateFactor {
    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [psobject]$InputObject,
        $ConstantRateFactor   
    )
    $InputObject.Arguments += " -crf " + $ConstantRateFactor
    return $InputObject 
}

function Join-VideoScale {
    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [psobject]$InputObject,
        $Height,
        $Width
    )

    switch ($true) {
        ($null -eq $Height -and $null -eq $Width) {
            return $InputObject
        }
        ($null -ne $Height -and $null -ne $Width) {
            $InputObject.Arguments += " -vf scale=" + $Width + ":" + $Height
            return $InputObject
        }
        ($null -ne $Height) { 
            $InputObject.Arguments += " -vf scale=" + $Height + ":-2" 
            return $InputObject 
        }
        ($null -ne $Width) { 
            $InputObject.Arguments += " -vf scale=" + "-2:" + $Width 
            return $InputObject 
        }
    }
}

function Join-Loglevel {
    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [psobject]$InputObject,
        $VerboseEnabled
    )
    if ($VerboseEnabled) {
        $InputObject.Arguments += " -loglevel verbose"
        return $InputObject 
    }
    else {
        $InputObject.Arguments += " -loglevel warning"
        return $InputObject 
    }
}

function Join-Trim {
    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [psobject]$InputObject,
        $TrimStart,
        $TrimEnd,
        $FfmpegPath,
        $SourceVideoPath
    )
    if ($null -ne $TrimStart) {
        $TrimStart = [timespan]::Parse($TrimStart)
    }
    if ($null -ne $TrimEnd) {
        $TrimEnd = [timespan]::Parse($TrimEnd)
    }
    
    if ($TrimStart -gt $TrimEnd -and $null -ne $TrimEnd) {
        Write-Error "TrimStart can not be equal to TrimEnd" -Category InvalidArgument
        break
    }
    if ($TrimStart -ge $TrimEnd -and $null -ne $TrimEnd) {
        Write-Error "TrimStart can not be greater than TrimEnd" -Category InvalidArgument
        break
    }
    $ActualVideoLenght = Measure-VideoLenght -SourceVideoPath $SourceVideoPath -FfmpegPath $FfmpegPath
   
    if ($TrimStart -gt $ActualVideoLenght) {
        Write-Error "TrimStart can not be greater than video lenght" -Category InvalidArgument
        break
    }

    if ($TrimEnd -gt $ActualVideoLenght) {
        Write-Error "TrimEnd can not be greater than video lenght" -Category InvalidArgument
        break
    }

    switch ($true) {
        ($null -eq $TrimStart -and $null -eq $TrimEnd) {
            return $InputObject
        }
        ($null -ne $TrimStart -and $null -ne $TrimEnd) {
            
            $ss = " -ss " + ("{0:hh\:mm\:ss}" -f $TrimStart)
            $to = " -to " + ("{0:hh\:mm\:ss}" -f $TrimEnd)
            $InputObject.Arguments += $ss + $to
            return $InputObject 
        }
        ($null -ne $TrimStart) { 
            $ss = " -ss " + ("{0:hh\:mm\:ss}" -f $TrimStart)
            $InputObject.Arguments += $ss
            return $InputObject
        }
        ($null -ne $TrimEnd) { 
            $to = " -to " + ("{0:hh\:mm\:ss}" -f $TrimEnd)
            $InputObject.Arguments += $to
            return $InputObject
        }
    }
}

function Join-Codec {
    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [psobject]$InputObject,
        $Encoder,
        $FfmpegPath,
        $SourceVideoPath
    )
    $Resultion = Measure-VideoResolution -FfmpegPath $FfmpegPath -SourceVideoPath $SourceVideoPath

    if ($null -eq $Encoder) {
        if ( $Resultion -gt 1080) {
            $Encoder = "libx265 -y"
        }
        else {
            $Encoder = "libx264 -y"
        }
    }
    $InputObject.Arguments += " -c:v " + $Encoder
    return $InputObject 
}

function Join-OutFileLiterallPath {
    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [psobject]$InputObject,
        $OutFileLiteralPath,
        $SourceVideoPath
    )

    if ($null -eq $OutFileLiteralPath) {
        $Filename = [IO.path]::GetFileNameWithoutExtension($SourceVideoPath)
        $Filepath = Split-Path ([IO.path]::GetFullPath( $SourceVideoPath ))
        $OutFileLiteralPath = Join-Path -path $Filepath  -ChildPath ($Filename + '_recoded.mp4')
        $InputObject.OutFileLiteralPath = $OutFileLiteralPath
        $InputObject.Arguments += ' "' + $OutFileLiteralPath + '"'
        return $InputObject 
    }
    else {
        $InputObject.OutFileLiteralPath = $OutFileLiteralPath
        $InputObject.Arguments += ' "' + $OutFileLiteralPath + '"'
        return $InputObject
    }
}

function ConvertTo-mp4 {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Path to one or more locations.")]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [psobject]$InputObject,
 
        [ValidateSet("Ultrafast", "Superfast", "Veryfast", "Faster", "Fast", "Medium ", "Slow", "Slower", "Veryslow", "Placebo")]
        [string]$Preset = "Veryslow",

        [Parameter(HelpMessage = "Highter is worse. Set to 0 for lossless.")]
        [ValidateRange(0, 51)]
        [UInt16]$Quality = 21,
    
        [ValidateSet("libx264", "libx265")]
        [string]$Encoder,

        [ValidateRange(0, 9999)]
        [UInt16]$Height,
        [ValidateRange(0, 9999)]
        [UInt16]$Width,
        [string]$OutFileLiteralPath,
        
        [ValidateScript( { $_ -match "(?:(?:([01]?\d|2[0-3]):)?([0-5]?\d):)?([0-5]?\d)" })]
        [timespan]$TrimStart,
        [ValidateScript( { $_ -match "(?:(?:([01]?\d|2[0-3]):)?([0-5]?\d):)?([0-5]?\d)" })]
        [timespan]$TrimEnd,
        [switch]$Force 
    )
    
    begin {
        $PathToModule = Split-Path (Get-Module -ListAvailable ConvertTo-MP4).Path
        $FfmpegPath = Join-Path (Split-Path $PathToModule) "ffmpeg"
        $Exec = (Join-Path -Path $FfmpegPath -ChildPath "ffmpeg.exe")
        $OutputArray = @()

        $yesToAll = $false
        $noToAll = $false

        $Location = Get-Location
    }
    
    process {    
        function New-FfmpegArgs {
            $VideoFile = $InputObject
            | Join-InputFileLiterallPath 
            | Join-Preset -Preset $Preset
            | Join-ConstantRateFactor -ConstantRateFactor $Quality
            | Join-VideoScale -Height $Height -Width $Width
            | Join-Loglevel -VerboseEnabled $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent
            | Join-Trim -TrimStart $TrimStart -TrimEnd $TrimEnd -FfmpegPath $FfmpegPath -SourceVideoPath ([IO.Path]::GetFullPath($InputObject))
            | Join-Codec -Encoder $Encoder -FfmpegPath $FfmpegPath -SourceVideoPath ([IO.Path]::GetFullPath($InputObject))
            | Join-OutFileLiterallPath -OutFileLiteralPath $OutFileLiteralPath -SourceVideoPath ([IO.Path]::GetFullPath($InputObject))
            Set-Location $Location
            return $VideoFile
        }

        if ($Force) {
            $continue = $true
        }

        $Arguments = New-FfmpegArgs
        $Verb = "Overwrite file: " + $Arguments.OutFileLiteralPath
       
        if (Test-Path $Arguments.OutFileLiteralPath) {
            $continue = $PSCmdlet.ShouldContinue($OutFileLiteralPath, $Verb, [ref]$yesToAll, [ref]$noToAll)
           
            if ($continue) {
                Start-Process $Exec -ArgumentList $Arguments.Arguments -NoNewWindow -Wait
              
                if (Test-Path $Arguments.OutFileLiteralPath) {
                    $OutputArray += Get-Item -Path $Arguments.OutFileLiteralPath
                }
            }
            else {
                break
            }
        }
        else {
            Start-Process $Exec -ArgumentList $Arguments.Arguments -NoNewWindow -Wait
           
            if (Test-Path $Arguments.OutFileLiteralPath) {
                $OutputArray += Get-Item -Path $Arguments.OutFileLiteralPath
            }
        }
    }
    end {
        return $OutputArray
    }
}