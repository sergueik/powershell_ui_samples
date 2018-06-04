function Get-Calendar {
  [CmdletBinding()]
  param(
    [Parameter(Position=0)]
    [Alias('m')]
    [ValidateRange(1, 2)]
    [Int32]$Month = ($script:d = Get-Date).Month,
    
    [Parameter(Position=1)]
    [Alias('y')]
    [ValidateRange(1970, 3000)]
    [Int32]$Year = (Get-Date).Year,
    
    [Parameter()]
    [Alias('bm')]
    [Switch]$BlueMonday
  )
  
  begin {
    $day, $dfi = "$($d.Day)".PadLeft(2, [Char]32), (Get-Culture).DateTimeFormat
    $arr, $cal = $dfi.ShortestDayNames, $dfi.Calendar
    
    $dow = [Int32]$cal.GetDayOfWeek("$Month" + '.1.' + "$Year")
    if ($BlueMonday) {
      $arr = $arr[1..$arr.Length] + $arr[0]
      if (($dow = --$dow) -lt 0) { $dow = 0 }
    }
  }
  process {
    $cap = $dfi.MonthNames[$Month - 1] + [Char]32 + $Year
    $cap = "$([Char]32)" * [Math]::Round((20 - $cap.Length) / 2) + $cap
    
    if ($dow -ne 0) { for ($i = 0; $i -lt $dow; $i++) { $arr += "$([Char]32)" * 2 } }
    $arr += 1..$cal.GetDaysInMonth($Year, $Month) | ForEach-Object {
      $_.ToString().PadLeft(2, [Char]32)
    }
  }
  end {
    Write-Host $cap -ForegroundColor Magenta
    for ($i = 0; $i -lt $arr.Length; $i += 6) {
      if (($itm = $arr[$i..($i + 6)]) -contains $day) {
        $cur, $pos = ($raw = $host.UI.RawUI).CursorPosition, $itm
      }
      Write-Host $itm
      $i++
    }
    
    if ($Month -ne $d.Month -or $Year -ne $d.Year) { return }
    $cur.X = ($x = [Array]::IndexOf($pos, $day)) * 2 + $x
    $raw.SetBufferContents($cur, $raw.NewBufferCellArray(
      [String[]]$day, [ConsoleColor]::Black, [ConsoleColor]::White
    ))
  }
}