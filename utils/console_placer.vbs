' origin: http://forum.oszone.net/thread-255310-2.html


Option Explicit

Const SW_NORMAL = 1

Dim objSWbemObjectEx_Win32_Process
Dim objSWbemObjectEx_Win32_ProcessStartup
Dim lngProcessID

Dim strCommandLine1
Dim strCommandLine2
Dim strCommandLine3

strCommandLine1 = "ping.exe -t 192.168.1.1"
strCommandLine2 = "ping.exe -t ex.ua"
strCommandLine3 = "ping.exe -t google.com"

With WScript.CreateObject("WbemScripting.SWbemLocator")
	With .ConnectServer(".", "root\cimv2")
		Set objSWbemObjectEx_Win32_Process        = .Get("Win32_Process")
		Set objSWbemObjectEx_Win32_ProcessStartup = .Get("Win32_ProcessStartup").SpawnInstance_

		With objSWbemObjectEx_Win32_ProcessStartup
			.ShowWindow = SW_NORMAL
			.CreateFlags = 16

			.X =  0
			.Y = 0

			.XSize = 640
			.YSize = 690

			.XCountChars = 40
			.YCountChars = 3000

			.Title = "Ping ROUTER"
			.FillAttribute = 2
		End With

		If objSWbemObjectEx_Win32_Process.Create(strCommandLine1, Empty, objSWbemObjectEx_Win32_ProcessStartup, lngProcessID) <> 0 Then
			WScript.Echo "Can't create process [" & strCommandLine1 & "]"
			WScript.Quit 1
		End If

		With objSWbemObjectEx_Win32_ProcessStartup
			.X = 680

			.XSize = 640
			.YSize = 330

			.Title = "Ping EX.UA"
			.FillAttribute = 4
		End With

		If objSWbemObjectEx_Win32_Process.Create(strCommandLine2, Empty, objSWbemObjectEx_Win32_ProcessStartup, lngProcessID) <> 0 Then
			WScript.Echo "Can't create process [" & strCommandLine2 & "]"
			WScript.Quit 2
		End If

		With objSWbemObjectEx_Win32_ProcessStartup
			.X = 685
			.Y = 365

			.XSize = 640
			.YSize = 330

			.Title = "Ping GOOGLE.com"
			.FillAttribute = 7
		End With

		If objSWbemObjectEx_Win32_Process.Create(strCommandLine3, Empty, objSWbemObjectEx_Win32_ProcessStartup, lngProcessID) <> 0 Then
			WScript.Echo "Can't create process [" & strCommandLine2 & "]"
			WScript.Quit 3
		End If
	End With
End With

WScript.Quit 0

