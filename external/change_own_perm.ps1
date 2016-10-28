# based on: http://shrekpoint.blogspot.com/2012/08/taking-ownership-of-dcom-registry.html
[string]$regPath = 'SOFTWARE\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}'
[string]$domainAccount = 'BUILTIN\Administrators'

# http://www.pinvoke.net/default.aspx/advapi32.adjusttokenprivileges
# http://www.pinvoke.net/default.aspx/advapi32.OpenProcessToken
function enablePrivilege {
  param(
    [ValidateSet(
      'SeAssignPrimaryTokenPrivilege','SeAuditPrivilege','SeBackupPrivilege',
      'SeChangeNotifyPrivilege','SeCreateGlobalPrivilege','SeCreatePagefilePrivilege',
      'SeCreatePermanentPrivilege','SeCreateSymbolicLinkPrivilege','SeCreateTokenPrivilege',
      'SeDebugPrivilege','SeEnableDelegationPrivilege','SeImpersonatePrivilege','SeIncreaseBasePriorityPrivilege',
      'SeIncreaseQuotaPrivilege','SeIncreaseWorkingSetPrivilege','SeLoadDriverPrivilege',
      'SeLockMemoryPrivilege','SeMachineAccountPrivilege','SeManageVolumePrivilege',
      'SeProfileSingleProcessPrivilege','SeRelabelPrivilege','SeRemoteShutdownPrivilege',
      'SeRestorePrivilege','SeSecurityPrivilege','SeShutdownPrivilege','SeSyncAgentPrivilege',
      'SeSystemEnvironmentPrivilege','SeSystemProfilePrivilege','SeSystemtimePrivilege',
      'SeTakeOwnershipPrivilege','SeTcbPrivilege','SeTimeZonePrivilege','SeTrustedCredManAccessPrivilege',
      'SeUndockPrivilege','SeUnsolicitedInputPrivilege')]
    $privilege,
    $processId = $pid,
    [switch]$disable
  )

  $type = Add-Type @'
using System;
using System.Runtime.InteropServices;
  
public class Helper {
    [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
    static extern bool AdjustTokenPrivileges(
    IntPtr tokenHandle, 
    bool disableAllPrivileges, 
    ref TOKEN_PRIVILEGES newState, 
    int bufferLengthInBytes, 
    IntPtr previousState, 
    IntPtr returnLengthInBytes);

    [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
    public static extern bool OpenProcessToken(IntPtr ProcessHandle, UInt32 DesiredAccess, ref IntPtr TokenHandle );

    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern bool LookupPrivilegeValue(string systemName, string privilegeName, ref long pluid);

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct TOKEN_PRIVILEGES {
        public int Count;
        public long Luid;
        public int Attr;
    }

    public const int SE_PRIVILEGE_ENABLED = 0x00000002;
    public const int SE_PRIVILEGE_DISABLED = 0x00000000;

    public const UInt32 STANDARD_RIGHTS_REQUIRED = 0x000F0000;
    public const UInt32 STANDARD_RIGHTS_READ = 0x00020000;
    public const UInt32 TOKEN_ASSIGN_PRIMARY = 0x0001;
    public const UInt32 TOKEN_DUPLICATE = 0x0002;
    public const UInt32 TOKEN_IMPERSONATE = 0x0004;
    public const UInt32 TOKEN_QUERY = 0x0008;
    public const UInt32 TOKEN_QUERY_SOURCE = 0x0010;
    public const UInt32 TOKEN_ADJUST_PRIVILEGES = 0x0020;
    public const UInt32 TOKEN_ADJUST_GROUPS = 0x0040;
    public const UInt32 TOKEN_ADJUST_DEFAULT = 0x0080;
    public const UInt32 TOKEN_ADJUST_SESSIONID = 0x0100;
    public const UInt32 TOKEN_READ = (STANDARD_RIGHTS_READ | TOKEN_QUERY);
    public const UInt32 TOKEN_ALL_ACCESS = ( STANDARD_RIGHTS_REQUIRED | TOKEN_ASSIGN_PRIMARY |
        TOKEN_DUPLICATE | TOKEN_IMPERSONATE | TOKEN_QUERY | TOKEN_QUERY_SOURCE |
        TOKEN_ADJUST_PRIVILEGES | TOKEN_ADJUST_GROUPS | TOKEN_ADJUST_DEFAULT |
        TOKEN_ADJUST_SESSIONID);
    
    public static bool EnablePrivilege(long processHandle, string privilege, bool disable) {
        bool retVal;
        TOKEN_PRIVILEGES tokenPrivileges;
        IntPtr hproc = new IntPtr(processHandle);
        IntPtr htok = IntPtr.Zero;
        retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
        tokenPrivileges.Count = 1;
        tokenPrivileges.Luid = 0;
        tokenPrivileges.Attr = (disable) ?  SE_PRIVILEGE_DISABLED : SE_PRIVILEGE_ENABLED;
        retVal = LookupPrivilegeValue(null, privilege, ref tokenPrivileges.Luid);
        retVal = AdjustTokenPrivileges(htok, false, ref tokenPrivileges, 0, IntPtr.Zero, IntPtr.Zero);
        return retVal;
    }
}
'@ -passthru

  $type[0]::EnablePrivilege(((Get-Process -Id $processId).'Handle'),$privilege,$disable)
}

if (-not (New-Object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Output 'need to run as administrator'
}
enablePrivilege 'SeTakeOwnershipPrivilege'
try {
  $key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($regPath,
    [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,
    [System.Security.AccessControl.RegistryRights]::takeownership)
  $acl = $key.GetAccessControl([System.Security.AccessControl.AccessControlSections]::None)
  $acl.SetOwner([System.Security.Principal.NTAccount]$domainAccount)
  $key.SetAccessControl($acl)

  $acl = $key.GetAccessControl()
  $rule = New-Object System.Security.AccessControl.RegistryAccessRule(
  [System.Security.Principal.NTAccount]$domainAccount,
  [System.Security.AccessControl.RegistryRights]'FullControl',
  # [System.Security.AccessControl.InheritanceFlags]'None'
  # [System.Security.AccessControl.PropagationFlags]'None'
  [System.Security.AccessControl.AccessControlType]'Allow')
  $acl.SetAccessRule($rule)
  $key.SetAccessControl($acl)
  $key.Close() } catch [exception]{
}
