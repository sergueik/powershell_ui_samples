# http://www.cyberforum.ru/powershell/thread2489600.html
# https://stackoverflow.com/questions/1283406/treenodecollection-find-doesnt-seem-to-work
# see also: http://www.cyberforum.ru/powershell/thread2488751.html
add-type -assembly System.Windows.Forms
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
$form.Controls.add($treeView)
# https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.treeview.nodes?view=netframework-4.0
$text = 'второй'
$text_key = $labels_hash[$text]
$treeNodes = $TreeView.Nodes.Find($text_key, $true)
if ($treeNodes -ne $null) {
  $treeView.SelectedNode = $treeNodes[0]
  write-debug 'Found via API call'
} else {
  $treeView.Nodes | where-object { $_.Text -eq $text } | select-object -first 1 | tee-object -variable 'treeNode' | select-object -property Text,FullPath | format-list
  $treeView.SelectedNode = $treeNode
  write-debug 'Found through iteration'
}

$treeView.Focus() | out-null
$form.ShowDialog() | out-null
