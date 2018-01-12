### Info


This directory contains the code from 
[Passing Parameters to a Running Application in WPF](https://www.codeproject.com/Articles/1224031/Passing-Parameters) article by Alex Schunk. 
When `App.UnsafeNative` is made public and embed in / controlled by a Powershell script:
```powershell

param(
  [string]$app = 'App',
  [string]$message = 'message',
  [boolean]$debug = $false
)

Add-Type -TypeDefinition @"

// "
using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Text;

namespace App {
   public class UnsafeNative {
...
    }
}
"@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Net.dll','System.Runtime.InteropServices.dll'

$process = Get-Process -ProcessName "${app}" 

$args = @( "Pid: ${pid}" , $message )


[App.UnsafeNative]::SendMessage(
  ([System.Diagnostics.Process]::GetProcessById($process.Id)).MainWindowHandle,
  [string]::Join(' ',$args)
)


```
the interaction between the two becomes possible:
 
![Example](https://github.com/sergueik/powershell_ui_samples/blob/master/external/csharp/wpf_io/screenshots/capture.png)

### Author
[Serguei Kouzmine](kouzmine_serguei@yahoo.com)
