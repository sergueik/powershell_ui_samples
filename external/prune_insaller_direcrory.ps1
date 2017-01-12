# origin: http://forum.oszone.net/showthread.php?s=b4638aa0c504273c30e27526445982c2&t=322618
# http://www.bryanvine.com/2015/06/powershell-script-cleaning-up.html

$msi = New-Object -ComObject "WindowsInstaller.Installer"
$savelist = @()
$products = $msi.GetType().InvokeMember("Products", "GetProperty", $null, $msi, $null)
foreach ($product in $products) {
	$patches = $msi.GetType().InvokeMember("Patches", "GetProperty", $null, $msi,  @($product))
	foreach($patch in $patches)	{
		$location = $msi.GetType().InvokeMember("PatchInfo", "GetProperty", $null, $msi, @($patch, "LocalPackage"))
		$savelist += [pscustomobject] @{
			ProductCode = $product
			PatchCode = $patch
			PatchLocation = $location
		}
	}
}

$filelocation = $savelist | select -ExpandProperty PatchLocation

# First pass to remove exact file names
dir C:\windows\Installer -file | ForEach-Object {
	$fullname = $_.FullName
	if ($filelocation | Where-Object {$_ -like "*$fullname*"}) {
		write-output "Keeping $fullname"
	} else {
		Remove-Item $fullname -Force -Verbose
	}
}

#second pass to match product and patch codes
dir C:\windows\Installer -Directory | ForEach-Object {
	$fullname = $_.name
	if ($savelist | Where-Object {$_.ProductCode -like "*$fullname*" -or $_.PatchCode -like "*$fullname*" }) {
		write-output "Keeping $fullname"
	} else {
		Remove-Item $_.fullname -Force -Verbose -Recurse
	}
}