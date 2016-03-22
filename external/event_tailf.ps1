# origin :http://poshcode.org/1061
#.Synopsis 
#  Show the last n lines of a text file
#.Description
#  This is just a tail script for PowerShell, using seekable streams to avoid reading the whole file and using v2 eventing to detect changes and provide a -Continuous mode.
#.Parameter Name
#  The file name to tail
#.Parameter Lines
#  The number of lines to display (or start with, in -Continuous mode)
#.Parameter Continuous
#  Whether or not to continue watching for new content to be added to the tail of the function
#.Parameter Linesep
#  Allows you to override the line separator character used for counting lines. 
#  By default we use `n, which works for Windows `r`n and Linux `n but not old-school Mac `r files
#.Parameter Encoding
#  Allows you to manually override the text encoding. 
#  By default we can detect various unicode formats, and we default to UTF-8 which will handle ASCII
#.Example
#  Get-FileTail ${Env:windir}\Windowsupdate.log 25
#
#  get the last 25 lines from the specified log
#.Example
#  Get-FileTail ${Env:windir}\Windowsupdate.log -Continuous
#
#  Start reading from WindowsUpdate.log as it is written to.

#function Get-FileTail {
PARAM( $Name, [int]$lines=10, [switch]$continuous, $linesep = "`n", [string]$encoding )
BEGIN {
   if(Test-Path $Name) {
      $Name = (Convert-Path (Resolve-Path $Name))
   }
   [byte[]]$buffer = new-object byte[] 1024

   if($encoding) { 
      [System.Text.Encoding]$encoding = [System.Text.Encoding]::GetEncoding($encoding) 
      Write-Debug "Specified Encoding: $encoding"
   }
   #  else { 
      #  $detector = New-Object System.IO.StreamReader $Name, $true
      #  [Text.Encoding]$encoding = $detector.CurrentEncoding
      #  Write-Debug "Detected Encoding:  $encoding"
      #  $detector.Dispose()
   #  }

   function tailf {
   PARAM($StartOfTail=0)
      [string[]]$content = @()
      #trap { return }
      ## You must use ReadWrite sharing so you can open files which other apps are writing to...
      $reader = New-Object System.IO.FileStream $Name, "OpenOrCreate", "Read", "ReadWrite", 8, "None"

      if(!$encoding) {
         $b1 = $reader.ReadByte()
         $b2 = $reader.ReadByte()
         $b3 = $reader.ReadByte()
         $b4 = $reader.ReadByte()

         if (($b1 -eq 0xEF) -and ($b2 -eq 0xBB) -and ($b3 -eq 0xBF)) {
            Write-Debug "Detected Encoding:  UTF-8"
            [System.Text.Encoding]$encoding = [System.Text.Encoding]::UTF8
         } elseif (($b1 -eq 0) -and ($b2 -eq 0) -and ($b3 -eq 0xFE) -and ($b4 -eq 0xFF)) {
            Write-Debug "Detected Encoding:  12001 UTF-32 Big-Endian"
            [System.Text.Encoding]$encoding = [System.Text.Encoding]::GetEncoding(12001)
         } elseif (($b1 -eq 0xFF) -and ($b2 -eq 0xFE) -and ($b3 -eq 0) -and ($b4 -eq 0)) {
            Write-Debug "Detected Encoding:  12000 UTF-32 Little-Endian"
            [System.Text.Encoding]$encoding = [System.Text.Encoding]::UTF32
         } elseif (($b1 -eq 0xFE) -and ($b2 -eq 0xFF)) {
            Write-Debug "Detected Encoding:  1201 UTF-16 Big-Endian"
            [System.Text.Encoding]$encoding = [System.Text.Encoding]::BigEndianUnicode
         } elseif (($b1 -eq 0xFF) -and ($b2 -eq 0xFE)) {
            Write-Debug "Detected Encoding:  1200 UTF-16 Little-Endian"
            [System.Text.Encoding]$encoding = [System.Text.Encoding]::Unicode
         } elseif (($b1 -eq 0x2B) -and ($b2 -eq 0x2F) -and ($b3 -eq 0x76) -and (
               ($b4 -eq 0x38) -or ($b4 -eq 0x39) -or ($b4 -eq 0x2b) -or ($b4 -eq 0x2f))) {
            Write-Debug "Detected Encoding:  UTF-7"
            [System.Text.Encoding]$encoding = [System.Text.Encoding]::UTF7
         } else {
            Write-Debug "Unknown Encoding: [$('0x{0:X}' -f $b1) $('0x{0:X}' -f $b2) $('0x{0:X}' -f $b3) $('0x{0:X}' -f $b4)] using UTF-8"
            [System.Text.Encoding]$encoding = [System.Text.Encoding]::UTF8
         }
      }
      
      #trap { Write-Warning $_; $reader.Close(); throw }
      if($StartOfTail -eq 0) {
         $StartOfTail = $reader.Length - $buffer.Length
      } else {
         $OnlyShowNew = $true
      }

      #Write-Verbose "Starting Tail: $StartOfTail of $($reader.Length)"

      do { 
         $pos = $reader.Seek($StartOfTail, "Begin")
         #Write-Verbose "Seek: $Pos"
         do {
            $count = $reader.Read($buffer, 0, $buffer.Length);
            #Write-Verbose "Read: $Count"
            $content += $encoding.GetString($buffer,0,$count).Split($linesep)
         } while( $count -gt 0 )
         $StartOfTail -= $buffer.Length
      # keep going if we don't have enough lines,
      } while(!$OnlyShowNew -and ($content.Length -lt $lines) -and $StartOfTail -gt 0)

      ## ADJUST OUR OUTPUT ...
      $end = $reader.Length
      #Write-Verbose "Ended Tail: $end of $($reader.Length)"
      
      if($content) {
         $output = [string]::Join( "`n", @($content[-$lines..-1]) )
         $len = $output.Length
         $output = $output.TrimEnd("`n")
         $end -= ($len - $output.Length) - 1
      }

      Write-Output $end
      if($output.Length -ge 1) {
         Write-Host $output -NoNewLine
      }
      #trap { continue }
      $reader.Close();
   }
}
PROCESS {
   [int]$StartOfTail = tailf 0

   if($continuous) { 
      $Null = unregister-event "FileChanged" -ErrorAction 0
      $fsw = new-object system.io.filesystemwatcher
      $fsw.Path = split-path $Name
      $fsw.Filter = Split-Path $Name -Leaf
      $fsw.EnableRaisingEvents = $true
      $null = Register-ObjectEvent $fsw Changed "FileChanged" -MessageData $Name 
      while($true) {
         wait-event FileChanged | % { 
            [int]$StartOfTail = tailf $StartOfTail -newonly
            $null = Remove-Event $_.EventIdentifier
         }
      }
      unregister-event "FileChanged"
   }
   Write-Host
}
#}