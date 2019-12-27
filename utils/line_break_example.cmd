@echo OFF
REM original single line version
"C:/Windows/system32/WindowsPowershell/v1.0/powershell.exe" -NoProfile -ExecutionPolicy unrestricted -command "&{ $debugpreference = 'Continue'; $data = @(); $obj = Get-Item "HKLM:\SYSTEM\CurrentControlSet\services\mcollective"; $n = $obj.Property.Count; $i = 0; while ($i -le $n) { $data += $obj.GetValue($obj.GetValueNames()[$i]); $i = $i + 1 }; $res = $data -join ','; write-debug ('Res = {0}' -f $res); return $res }"


REM Added line breaks for readability

"C:/Windows/system32/WindowsPowershell/v1.0/powershell.exe" ^
-NoProfile -ExecutionPolicy unrestricted ^
-command "&{ $debugpreference = 'Continue'; $data = @(); $obj = Get-Item "HKLM:\SYSTEM\CurrentControlSet\services\mcollective"; $n = $obj.Property.Count; $i = 0; while ($i -le $n) { $data += $obj.GetValue($obj.GetValueNames()[$i]); $i = $i + 1 }; $res = $data -join ','; write-debug ('Res = {0}' -f $res); return $res }"

	
REM cannot break lines and add a caret before every line end
REM because of the special meaning of the "&" for the cmd shell:
"C:/Windows/system32/WindowsPowershell/v1.0/powershell.exe" -NoProfile -ExecutionPolicy unrestricted -command ^
"^&{ $debugpreference = 'Continue'; $data = @(); $obj = Get-Item "HKLM:\SYSTEM\CurrentControlSet\services\mcollective"; $n = $obj.Property.Count; $i = 0; while ($i -le $n) { $data += $obj.GetValue($obj.GetValueNames()[$i]); $i = $i + 1 }; $res = $data -join ','; write-debug ('Res = {0}' -f $res); return $res }"

REM uncomment to see the error
REM '{' is not recognized as an internal or external command, operable program or batch file.
goto :EOF

"C:/Windows/system32/WindowsPowershell/v1.0/powershell.exe" ^
-NoProfile -ExecutionPolicy unrestricted ^
-command ^
"&{ $debugpreference = 'Continue'; $data = @(); $obj = Get-Item "HKLM:\SYSTEM\CurrentControlSet\services\mcollective"; $n = $obj.Property.Count; $i = 0; while ($i -le $n) { $data += $obj.GetValue($obj.GetValueNames()[$i]); $i = $i + 1 }; $res = $data -join ','; write-debug ('Res = {0}' -f $res); return $res }"
