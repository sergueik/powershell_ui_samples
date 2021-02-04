# ConvertTo-mp4

The script checks the logs and adds the ip address to the firewall rule depending on the specified parameters.

``` Powershell
ConvertTo-mp4
[-InputObject  <PSObject>]
[-Preset  <string>]
[-Quality  <UInt16>]
[-Encoder  <string>]
[-Height  <UInt16>]
[-Width  <UInt16>]
[-OutFileLiteralPath  <string>]
[-TrimStart <timespan>]
[-TrimStart <TrimEnd>]
[-Force <switch>]
```

# Description

List of parameters for **ConvertTo-mp4**:

* InputObject
* Preset
* Quality
* Encoder
* Height
* Width
* OutFileLiteralPath
* TrimStart
* TrimEnd
* Force

_InputObject_ Path to one or more objects, literall path to object, object from pipeline.

_Preset_ ffmpeg parameter - Preset.

_Quality_ ffmpeg parameter - crf.

_Encoder_ ffmpeg parameter - c:v.

_Height_ Set ffmpeg parameter block to use height parameter with or without Widt parameter set.

_Width_ Set ffmpeg parameter block to use Width parameter with or without height parameter set.

_OutFileLiteralPath_ Out file literall path.

_TrimStart_ Cut video file from start to value in HH:MM:SS format.

_TrimEnd_Cut video file from end to value in HH:MM:SS format.

_Force_ Force rewrite files without asking user.

## Examples

#### Example 1: Simple

Convert selected videofile

``` Powershell
ConvertTo-mp4 -InputObject C:\Videos\input.mp4
```

#### Example 2: Recode every file in selected folder

The module adds outputs
```Powershell
Get-ChildItem -Path "C:\Videos\" | ConvertTo-mp4 -Preset Ultrafast
```

#### Example 3: Advanced

Combining command to make joke script. Recode files and remove them after recoding.
```Powershell
Get-ChildItem -Path "C:\Videos\" | ConvertTo-mp4 -Preset Ultrafast | Remove-Item
```
