<#
http://stackoverflow.com/questions/5843633/how-to-use-wpf-datagrid-net-4-0-in-powershell-ise
https://showui.codeplex.com/discussions/270755
http://stackoverflow.com/questions/18553746/powershell-dataviewgrid-column-autosize
http://gallery.technet.microsoft.com/scriptcenter/3dcf0354-e7a7-482c-86f1-2e75809a502d
http://sev17.com/2009/08/02/building-powershell-guis-with-primal-forms/
#>
New-Module -ScriptBlock {
[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void] [System.Reflection.Assembly]::LoadWithPartialName('System.ComponentModel')
[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Data')
[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing') 

#     [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    $form = New-Object System.Windows.Forms.Form
 
    $grid = New-Object System.Windows.Forms.PropertyGrid
    $grid.Dock = [System.Windows.Forms.DockStyle]::Fill
 
    $button = New-Object System.Windows.Forms.Button
    $button.Text = "OK"
    $button.Dock = [System.Windows.Forms.DockStyle]::Bottom
 
    $form.Controls.Add($button)
    $form.Controls.Add($grid)
 
    # Item to return, not null for OK
    $item = $null
 
    $button.add_Click(
        {
            # Set the return item
            $item = $grid.SelectedObject
            $form.Close()
        }
    )
    function Edit-Object($obj) {
        # Item to return, null for Cancel
        $item = $null
        $grid.SelectedObject = $obj
	# TODO customize column headers 
        # $grid.DataSource =  $obj
        $form.ShowDialog() | Out-Null
        return $item
    }
    Export-ModuleMember -Function Edit-Object
} | Out-Null
 
cls


function display_result{
param ([Object] $result_remote)

$Object1 = New-Object PSObject   

$cnt = 0 ;
foreach ($alias in $result_remote.keys){
$value = $result_remote[$alias]
if ($value -match 'DBMSSOCN,(.+),(.+)' ){
               $Object1 | add-member Noteproperty "_0${cnt}_Alias"  $alias
               $Object1 | add-member Noteproperty "_0${cnt}_Server" $matches[1]
               $Object1 | add-member Noteproperty "_0${cnt}_Port"   $matches[2]
               $Object1 | add-member Noteproperty "_0${cnt}_ZBlank"  ''

$cnt ++
}
}


$ret = (Edit-Object $Object1)
if ($ret) {
    $ret
}

}

$result_remote =  @{}
$result_remote['server1']  =  'DBMSSOCN,192.168.0.1,3655'

display_result  $result_remote
