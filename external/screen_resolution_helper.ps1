# Alternative method:
# https://github.com/timmui/ScreenResolutionChanger
# http://dotnet.mvps.org/dotnet/faqs/?id=setscreenresolution&lang=en
# http://www.codeproject.com/Articles/6810/Dynamic-Screen-Resolution

$helper_type_namespace = ('Util_{0}' -f (([guid]::NewGuid()) -replace '-',''))
$helper_type_name = 'ScreenResolutionHelper'

Add-Type -UsingNamespace @(
  'System.Windows.Forms'
) -MemberDefinition @'
public void showScreenResolution(){
  System.Drawing.Rectangle workingRectangle = Screen.PrimaryScreen.WorkingArea;
  Console.Error.WriteLine("Width: {0}\nHeight: {1}\n",  workingRectangle.Width, workingRectangle.Height);
}
'@ -ReferencedAssemblies @( 'System.Windows.Forms.dll' ) -Namespace $helper_type_namespace -Name $helper_type_name -ErrorAction Stop
$helper = New-Object -TypeName ('{0}.{1}' -f $helper_type_namespace,$helper_type_name)

try {
  $helper.showScreenResolution()
} catch [exception]{
  Write-Output ("Ignoring exception:`n{0}" -f $_.Exception.Message)
}
