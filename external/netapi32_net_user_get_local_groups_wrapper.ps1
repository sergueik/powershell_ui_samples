# origin: http://www.pinvoke.net/default.aspx/netapi32.netusergetlocalgroups
# https://github.com/GreatFireWall/Win32API/blob/master/Win32API/Win32/NetApi32.cs
$TypeDefinition = @"
using System;
using System.Runtime.InteropServices;
using System.Collections;

//LG_INCLUDE_INDIRECT=1
namespace Netapi32Wrapper {

	[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
	internal struct LOCALGROUP_USERS_INFO_0 {
	[MarshalAs(UnmanagedType.LPWStr)]
	internal string name;
	}

	public static class api {

	[DllImport("Netapi32.dll", SetLastError = true)]
	public extern static Int64 NetUserGetLocalGroups(
		[MarshalAs(UnmanagedType.LPWStr)] string servername,
		[MarshalAs(UnmanagedType.LPWStr)] string username,
		Int64 level,
		Int64 flags,
		out IntPtr bufptr,
		Int64 prefmaxlen,
		out Int64 entriesread,
		out Int64 totalentries);

	[DllImport("Netapi32.dll", SetLastError = true)]
	public static extern Int64 NetApiBufferFree(IntPtr Buffer);
	}

	public class NetUtilWrapper : IDisposable {

	// Creates a new wrapper for the local machine
	public NetUtilWrapper() { }

	// Disposes of this wrapper
	public void Dispose() { GC.SuppressFinalize(this); }

	public ArrayList GetUserLocalGroups(string ServerName, string Username, Int64 Flags) {

		ArrayList myList = new ArrayList();
		Int64 EntriesRead;
		Int64 TotalEntries;
		IntPtr bufPtr;
		//int ErrorCode;
		//string _ErrorMessage;

		api.NetUserGetLocalGroups(ServerName, Username, 0, Flags, out bufPtr, 1024, out EntriesRead, out TotalEntries);
		//ErrorCode = api.NetUserGetLocalGroups(ServerName,Username,0,Flags,out bufPtr,1024,out EntriesRead, out TotalEntries);
		//if (ErrorCode==0) { _ErrorMessage="Successful"; }
		//else { _ErrorMessage="Username or computer not found"; }

		//if (Flags>1) _ErrorMessage="Flags can only be 0 or 1";

		if (EntriesRead > 0) {
		LOCALGROUP_USERS_INFO_0[] RetGroups = new LOCALGROUP_USERS_INFO_0[EntriesRead];
		IntPtr iter = bufPtr;
		for (Int64 i = 0; i < EntriesRead; i++) {
			RetGroups[i] = (LOCALGROUP_USERS_INFO_0)Marshal.PtrToStructure(iter, typeof(LOCALGROUP_USERS_INFO_0));
			iter = (IntPtr)((Int64)iter + (Int64)Marshal.SizeOf(typeof(LOCALGROUP_USERS_INFO_0)));
			myList.Add(RetGroups[i].name);
		}

		api.NetApiBufferFree(bufPtr);
		}

		return myList;
	} //GetUserLocalGroups

	// Occurs on destruction of the Wrapper
	~NetUtilWrapper() { Dispose(); }

	} // wrapper class
} // namespace
"@
if ([intptr]::Size -eq 4) { $TypeDefinition = $TypeDefinition.Replace('Int64','Int32') }
Add-Type -TypeDefinition $TypeDefinition
$Netapi = New-Object Netapi32Wrapper.NetUtilWrapper

$Netapi.GetUserLocalGroups('.','vagrant',0)