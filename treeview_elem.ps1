# http://www.cyberforum.ru/powershell/thread2489600.html
# https://stackoverflow.com/questions/1283406/treenodecollection-find-doesnt-seem-to-work
# see also: http://www.cyberforum.ru/powershell/thread2488751.html
add-type -assembly System.Windows.Forms
add-type -assembly System.Drawing
$form = new-object System.Windows.Forms.Form
$treeView = new-object System.Windows.Forms.TreeView
$labels = @(
  'первый',
  'второй',
  'третий',
  'четвертый',
  'пятый',
  'шестой',
  'седьмой',
  'восьмой'
)

$labels_hash = @{}
$cnt = 0
$labels | foreach-object {
  $cnt ++
  $labels_hash[$_] = $cnt
}
<#
$labels = @{
  'первый' = 1;
  'второй' = 2;
  'третий' = 3;
  'четвертый' = 4;
  'пятый' = 5;
  'шестой' = 6;
  'седьмой' = 7;
  'восьмой' =  8;
}
#>
# Missing '=' operator after key in hash literal.
$labels | foreach-object {
  $text = $_
  $key = $labels_hash[$text]
  $treeView.Nodes.Add($key, $text) | out-null
}

$treeView.Nodes[3].Nodes.Add(42,"сорок второй")
$form.Controls.add($treeView)



# https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.treeview.nodes?view=netframework-4.0
# added the next level subnode for demo
$text = 'сорок второй'
$labels_hash[$text] = 42
$text_key = $labels_hash[$text]

# find it via deep search
# https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.treenodecollection.find?view=netframework-4.5
[bool]$searchAllChildren = $true
$treeNodes = $TreeView.Nodes.Find($text_key, $searchAllChildren )
if ($treeNodes -ne $null) {
  $treeView.SelectedNode = $treeNodes[0]
  write-debug 'Found via API call'
} else {
  $treeView.Nodes | where-object { $_.Text -eq $text } | select-object -first 1 | tee-object -variable 'treeNode' | select-object -property Text,FullPath | format-list
  $treeView.SelectedNode = $treeNode
  write-debug 'Found through iteration'
}
[System.Windows.Forms.Panel] $panel = new-object System.Windows.Forms.Panel
$form.Controls.add($panel)
# https://toster.ru/q/661139?e=7999788#clarification_745428
$load_code = {
  [System.Drawing.Graphics] $g = [System.Drawing.Graphics]::FromHwnd($panel.Handle)
  write-host 'Load event'
  write-host $g.VisibleClipBounds.Size.Width
  $arrayPoint = @(@( 140, 120, 180, 140 ), @( 70, 100, 60, 40 ))
  # http://www.java2s.com/Code/CSharp/2D-Graphics/DrawPolygon.htm
  $rc = New-Object System.Drawing.Rectangle (10,20,150,180)
  $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::Purple)
  $g.FillRectangle($brush,$rc)
}

function paint_code {
  param(
    [Object]$sender,
    [EventArgs]$e
    )
  [System.Drawing.Graphics] $g = [System.Drawing.Graphics]::FromHwnd($panel.Handle)
  write-host "Paint code"
  write-host $g.VisibleClipBounds.Size.Width
  $arrayPoint = @(@( 140, 120, 180, 140 ), @( 70, 100, 60, 40 ))
  # http://www.java2s.com/Code/CSharp/2D-Graphics/DrawPolygon.htm
  $rc = New-Object System.Drawing.Rectangle (10,50,150,150)
  $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::Green)
  $g.FillRectangle($brush,$rc)
}
      
$form.add_Load($load_code)
$form.add_Paint({ paint_code })
# https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.panel?view=netframework-4.5

$treeView.Focus() | out-null
$form.ShowDialog() | out-null
