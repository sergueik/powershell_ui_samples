# origin http://stackoverflow.com/questions/15775488/determine-if-net-assembly-is-mixed-mode-without-calling-external-exe-in-powersh
#
# Gets the Platform of a any Assembly native or managed.
# Examples:
#   Get-Platform "C:\vs\projects\bestprojectever\bin\debug\mysweetproj.dll"
#   Get-Platform (dir *.dll | select -first 1) 

param([Parameter(Mandatory=$true, ValueFromPipeline=$true)] $assemblyPath)

$platform = "Unknown"
$resolvedPath = Resolve-Path -literalPath $assemblyPath

try {
    $architecture = [System.Reflection.AssemblyName]::GetAssemblyName($resolvedPath) | Select-Object -ExpandProperty ProcessorArchitecture
    switch ($architecture) {
        MSIL { $platform = "AnyCPU Managed" }
        X86 { $platform = "x86 Managed" }
        Amd64 { $platform = "x64 Managed" }
        IA64 { $platform = "Itanium Managed" }
        default { $platform = "Unknown Managed" }
    }
}
catch [System.BadImageFormatException] {
    try {
        $assemblyStream = [System.IO.File]::OpenRead($resolvedPath)
        try {
            $binaryReader = New-Object System.IO.BinaryReader($assemblyStream)
            if ($binaryReader.ReadUInt16() -eq 0x5A4D)
            {
                $ignore = $assemblyStream.Seek(0x3c, [System.IO.SeekOrigin]::Begin)
                $pos = $binaryReader.ReadInt32()
                $ignore = $assemblyStream.Seek($pos, [System.IO.SeekOrigin]::Begin)
                $format = $binaryReader.ReadUInt32()
                if ($format -eq 0x4550)
                {
                    $machineType = $binaryReader.ReadUInt16()
                }
            }
        }
        finally {
            if ($binaryReader -ne $null) {
                $binaryReader.Close();
                if ($binaryReader.psbase -eq $null) {
                    $binaryReader.Dispose()
                } else {
                    $binaryReader.psbase.Dispose()
                }
            }
        }
    }
    finally
    {
        if ($assemblyStream -ne $null) {
            $assemblyStream.Close();
            if ($assemblyStream.psbase -eq $null) {
                $assemblyStream.Dispose()
            } else {
                $assemblyStream.psbase.Dispose()
            }
        }
    }
    switch ($format)
    {
        0x454C { $platform = "Virtual Device Driver Native" }
        0x454E { $platform = "16bit Native" }
        0x4550
        {
            switch ($machineType)
            {
                0x14c { $platform = "x86 Native" }
                0x166 { $platform = "R4000 Native" }
                0x169 { $platform = "MIPS WCE v2 Native" }
                0x1a2 { $platform = "Hitachi SH3 Native" }
                0x1a3 { $platform = "Hitachi SH3 DSP Native" }
                0x1a6 { $platform = "Hitachi SH4 Native" }
                0x1a8 { $platform = "Hitachi SH5 Native" }
                0x1c0 { $platform = "ARM Native" }
                0x1c2 { $platform = "Thumb Native" }
                0x1d3 { $platform = "Matsushita AM33 Native" }
                0x1f0 { $platform = "Power PC Native" }
                0x1f1 { $platform = "Power PC with floating point support Native" }
                0x200 { $platform = "IA64 Native" }
                0x266 { $platform = "MIPS16 Native" }
                0x366 { $platform = "MIPS with FPU Native" }
                0x466 { $platform = "MIPS16 with FPU Native" }
                0xebc { $platform = "EFI Byte Code Native" }
                0x8664 { $platform = "x64 Native" }
                0x9041 { $platform = "Mitsubishi M32R Native" }
                0xc0ee { $platform = "Pure MSIL" }
                default { $platform = "Unknown Native" }
            }
        }
        default { $platform = "Unknown Format" }
    }
}

return $platform
