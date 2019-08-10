# http://www.cyberforum.ru/powershell/thread2489600.html
# see also: http://www.cyberforum.ru/powershell/thread2488751.html
add-type -assembly System.Windows.Forms
$form = New-Object System.Windows.Forms.Form
$treeView = New-Object System.Windows.Forms.TreeView
@(
  'первый',
  'второй',
  'третий',
  'четвертый',
  'пятый',
  'шестой',
  'седьмой',
  'восьмой'
) | foreach-object {
  $text = $_
  $treeView.Nodes.Add($text) | out-null
}
$form.Controls.add($treeView)
# https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.treeview.nodes?view=netframework-4.0
$text = 'Второй'
$treeNodes = $TreeView.Nodes.Find($text, $true)
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
