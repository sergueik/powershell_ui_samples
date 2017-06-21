# origin: https://github.com/jfromaniello/pswatch
function watch {
  param([string]$location = '',
    [switch]$includeSubdirectories = $true,
    [switch]$includeChanged = $true,
    [switch]$includeRenamed = $true,
    [switch]$includeCreated = $true,
    [switch]$includeDeleted = $false)

  if ($location -eq '') {
    $location = Get-Location
  }

  $watcher = New-Object System.IO.FileSystemWatcher
  $watcher.Path = $location
  $watcher.IncludeSubdirectories = $includeSubdirectories
  $watcher.EnableRaisingEvents = $false
  $watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::FileName

  $conditions = 0
  if ($includeChanged) {
    $conditions = [System.IO.WatcherChangeTypes]::Changed
  }

  if ($includeRenamed) {
    $conditions = $conditions -bor [System.IO.WatcherChangeTypes]::Renamed
  }

  if ($includeCreated) {
    $conditions = $conditions -bor [System.IO.WatcherChangeTypes]::Created
  }

  if ($includeDeleted) {
    $conditions = $conditions -bor [System.IO.WatcherChangeTypes]::Deleted
  }

  while ($true) {
    $result = $watcher.WaitForChanged($conditions,1000);
    if ($result.TimedOut) {
      continue;
    }
    $filepath = [System.IO.Path]::Combine($location,$result.Name)
    New-Object Object |
    Add-Member NoteProperty Path $filepath -Passthru |
    Add-Member NoteProperty Operation $result.ChangeType.ToString() -Passthru |
    Write-Output
  }
}
