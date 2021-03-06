<#
Retrieve Firewall Settings
Use the XML to retrieve the Group Policy Firewall settings.
The attached XML (GPResult.XML) was produced using "GPResults /x".
The DOM nodes of interest are
"Rsop.ComputerResults.GPO"
and
"Rsop.ComputerResults.ExtensionData.Extension"
The GPO settings are defined under "Rsop.ComputerResults.ExtensionData.Extension",
but the friendly GPO name needs to be retrieved from "Rsop.ComputerResults.GPO".

The object need to retrieve the status for all profiles,
DomainProfile,
PublicProfile and
PrivateProfile.

The output should return (in one line) the friendly name of the GPO and the firewall status.

When no GPOs were defined/found, then return None.

#>

# $debugpreference='Continue'
param (
  [Boolean]$use_inline_data = $false,
  [switch]$debug
)
$debug_run = [bool]$PSBoundParameters['debug'].IsPresent
if ($DebugPreference -match '^Continue$') {
  $debug_run = $true
}
if ($use_inline_data -eq $false ) {
$data_path = "${env:USERPROFILE}\Downloads\GPResult.xml"

$o = [xml]( get-content -path $data_path )
} else {

$o = [xml]( @'
<?xml version="1.0" encoding="utf-16"?>
<Rsop xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.microsoft.com/GroupPolicy/Rsop">
  <ReadTime>2019-01-14T16:57:01.6661721Z</ReadTime>
  <DataType>LoggedData</DataType>
  <UserResults>
    <Version>2228228</Version>
    <Name>TestDomain\TestUser</Name>
    <TestDomain>TestDomain.Local</TestDomain>
    <SOM>TestDomain.Local</SOM>
    <Site>TestSite</Site>
    <SearchedSOM>
      <Path>Local</Path>
      <Type>Local</Type>
      <Order>1</Order>
      <BlocksInheritance>false</BlocksInheritance>
      <Blocked>false</Blocked>
      <Reason>Normal</Reason>
    </SearchedSOM>
    <SearchedSOM>
      <Path>TestDomain.Local/Configuration/Sites/TestSite</Path>
      <Type>Site</Type>
      <Order>2</Order>
      <BlocksInheritance>false</BlocksInheritance>
      <Blocked>false</Blocked>
      <Reason>Normal</Reason>
    </SearchedSOM>
    <SearchedSOM>
      <Path>TestDomain.Local</Path>
      <Type>TestDomain</Type>
      <Order>3</Order>
      <BlocksInheritance>false</BlocksInheritance>
      <Blocked>false</Blocked>
      <Reason>Normal</Reason>
    </SearchedSOM>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-513</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\TestDomain Users</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-1-0</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Everyone</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-2382043191-1234567891-1017</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestSQL\SophosUser</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-2973276235-1234567891-1019</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestSQL\SophosAdministrator</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-32-545</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">BUILTIN\Users</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-32-544</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">BUILTIN\Administrators</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-14</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT AUTHORITY\REMOTE INTERACTIVE LOGON</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-4</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT AUTHORITY\INTERACTIVE</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-11</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT AUTHORITY\Authenticated Users</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-15</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT AUTHORITY\This Organization</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-2-0</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">LOCAL</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-4526</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\administrative</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-512</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\TestDomain Admins</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-520</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\Group Policy Creator Owners</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-516</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\TestDomain Controllers</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-17986</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\Test Employees</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-518</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\Schema Admins</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-519</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\Enterprise Admins</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-18-1</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Authentication authority asserted identity</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-18478</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\SophosAdministrator</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-18476</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\SophosUser</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-1134</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\ServerName Authors</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-2108</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\Debugger Users</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-572</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\Denied RODC Password Replication Group</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-1133</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\ServerName Admins</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-1457</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\DnsAdmins</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-16-12288</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Mandatory Label\High Mandatory Level</Name>
    </SecurityGroup>
    <SlowLink>false</SlowLink>
    <ExtensionStatus>
      <Name>Group Policy Local Users and Groups</Name>
      <Identifier>{17D89FEC-5C44-4972-B12D-241CAEF74509}</Identifier>
      <BeginTime>2019-01-11T15:16:32</BeginTime>
      <EndTime>2019-01-11T15:16:32</EndTime>
      <LoggingStatus>Complete</LoggingStatus>
      <Error>0</Error>
    </ExtensionStatus>
    <ExtensionStatus>
      <Name>Deployed Printer Connections</Name>
      <Identifier>{8A28E2C5-8D06-49A4-A08C-632DAA493E17}</Identifier>
      <BeginTime>2019-01-11T15:16:32</BeginTime>
      <EndTime>2019-01-11T15:16:32</EndTime>
      <LoggingStatus>Complete</LoggingStatus>
      <Error>0</Error>
    </ExtensionStatus>
    <ExtensionStatus>
      <Name>Group Policy Infrastructure</Name>
      <Identifier>{00000000-0000-0000-0000-000000000000}</Identifier>
      <BeginTime>2019-01-14T16:49:57</BeginTime>
      <EndTime>2019-01-14T16:50:13</EndTime>
      <LoggingStatus>Complete</LoggingStatus>
      <Error>0</Error>
    </ExtensionStatus>
    <ExtensionStatus>
      <Name>Registry</Name>
      <Identifier>{35378EAC-683F-11D2-A89A-00C04FBBCFA2}</Identifier>
      <BeginTime>2019-01-11T15:16:32</BeginTime>
      <EndTime>2019-01-11T15:16:32</EndTime>
      <LoggingStatus>Complete</LoggingStatus>
      <Error>0</Error>
    </ExtensionStatus>
    <ExtensionStatus>
      <Name>Group Policy Drive Maps</Name>
      <Identifier>{5794DAFD-BE60-433f-88A2-1A31939AC01F}</Identifier>
      <BeginTime>2019-01-11T15:16:32</BeginTime>
      <EndTime>2019-01-11T15:16:32</EndTime>
      <LoggingStatus>Complete</LoggingStatus>
      <Error>0</Error>
    </ExtensionStatus>
    <ExtensionStatus>
      <Name>Group Policy Printers</Name>
      <Identifier>{BC75B1ED-5833-4858-9BB8-CBF0B166DF9D}</Identifier>
      <BeginTime>2019-01-11T15:16:32</BeginTime>
      <EndTime>2019-01-11T15:16:37</EndTime>
      <LoggingStatus>Complete</LoggingStatus>
      <Error>0</Error>
    </ExtensionStatus>
    <ExtensionStatus>
      <Name>Folder Redirection</Name>
      <Identifier>{25537BA6-77A8-11D2-9B6C-0000F8080861}</Identifier>
      <BeginTime>2019-01-11T15:16:32</BeginTime>
      <EndTime>2019-01-11T15:16:32</EndTime>
      <LoggingStatus>Complete</LoggingStatus>
      <Error>0</Error>
    </ExtensionStatus>
    <GPO>
      <Name>{8D1AA99C-242E-4FB5-B424-F8032A5FAAD8}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8D1AA99C-242E-4FB5-B424-F8032A5FAAD8}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>3</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>5</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>{EB1292B0-4693-453D-BC73-A7E9E3A90B28}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{EB1292B0-4693-453D-BC73-A7E9E3A90B28}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>11</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>13</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>Desktop Redirection</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{0D58CEF2-7134-4F34-AF14-4CB943DB1879}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>6</VersionDirectory>
      <VersionSysvol>6</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local/Configuration/Sites/TestSite</SOMPath>
        <SOMOrder>1</SOMOrder>
        <AppliedOrder>6</AppliedOrder>
        <LinkOrder>2</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>true</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>Folder Redirection</ExtensionName>
    </GPO>
    <GPO>
      <Name>{401E1247-8143-425E-8D36-E5B53546D0A6}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{401E1247-8143-425E-8D36-E5B53546D0A6}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>9</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>11</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>Set Point&amp;Print Settings</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>3</VersionDirectory>
      <VersionSysvol>3</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>14</SOMOrder>
        <AppliedOrder>4</AppliedOrder>
        <LinkOrder>16</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>Registry</ExtensionName>
    </GPO>
    <GPO>
      <Name>{48C91754-D454-4371-A96D-7D699FF79E39}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{48C91754-D454-4371-A96D-7D699FF79E39}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>16</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>18</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>{D351D153-5F0B-43FA-9221-4C3153B7E8F6}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{D351D153-5F0B-43FA-9221-4C3153B7E8F6}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>8</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>10</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>{9C94FC30-D9D9-49F5-9683-37A7AA6CCBF4}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{9C94FC30-D9D9-49F5-9683-37A7AA6CCBF4}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>15</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>17</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>{108C814F-EF5F-43F0-98E3-24D28CC31E49}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{108C814F-EF5F-43F0-98E3-24D28CC31E49}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>1</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>3</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>true</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>{0C123D08-E7BC-4060-93B2-9A7CB029FCF6}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{0C123D08-E7BC-4060-93B2-9A7CB029FCF6}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>7</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>9</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>6</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>8</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>Map Drives</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{44803AF6-5BB2-4103-8867-2CF6DB57AB0E}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>14</VersionDirectory>
      <VersionSysvol>14</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>4</SOMOrder>
        <AppliedOrder>2</AppliedOrder>
        <LinkOrder>6</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>Group Policy Drive Maps</ExtensionName>
      <ExtensionName>Group Policy Infrastructure</ExtensionName>
    </GPO>
    <GPO>
      <Name>Default TestDomain Policy</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>16</VersionDirectory>
      <VersionSysvol>16</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>17</SOMOrder>
        <AppliedOrder>5</AppliedOrder>
        <LinkOrder>19</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>true</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>Registry</ExtensionName>
      <ExtensionName>{3060E8D0-7020-11D2-842D-00C04FA372D4}</ExtensionName>
      <ExtensionName>Group Policy Local Users and Groups</ExtensionName>
      <ExtensionName>Group Policy Infrastructure</ExtensionName>
    </GPO>
    <GPO>
      <Name>Test HomeDir</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{028FC632-2F46-4C50-B725-6A15C97CD7AA}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>51</VersionDirectory>
      <VersionSysvol>51</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>13</SOMOrder>
        <AppliedOrder>3</AppliedOrder>
        <LinkOrder>15</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <SecurityFilter>TestDomain\Test Employees</SecurityFilter>
      <ExtensionName>Deployed Printer Connections</ExtensionName>
      <ExtensionName>Folder Redirection</ExtensionName>
    </GPO>
    <GPO>
      <Name>Local Group Policy</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">LocalGPO</Identifier>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>Local</SOMPath>
        <SOMOrder>1</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>1</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>{985715F9-9911-415E-973A-B4A2EEFB38AB}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{985715F9-9911-415E-973A-B4A2EEFB38AB}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>12</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>14</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>{2D45E698-90BC-4C88-9EF4-0840082C5D0B}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D45E698-90BC-4C88-9EF4-0840082C5D0B}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>10</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>12</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>true</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>Deploy Shared Printers</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{B3E43407-D9FF-4202-A878-55E9D16703C7}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>26</VersionDirectory>
      <VersionSysvol>26</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>2</SOMOrder>
        <AppliedOrder>1</AppliedOrder>
        <LinkOrder>4</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>Group Policy Printers</ExtensionName>
      <ExtensionName>Group Policy Infrastructure</ExtensionName>
    </GPO>
    <GPO>
      <Name>{E7CCD934-0AB0-4B37-B71C-ADAC9923E8BD}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{E7CCD934-0AB0-4B37-B71C-ADAC9923E8BD}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>5</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>7</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <ExtensionData>
      <Extension xmlns:q1="http://www.microsoft.com/GroupPolicy/Settings/Lugs" xsi:type="q1:LugsSettings" xmlns="http://www.microsoft.com/GroupPolicy/Settings">
        <q1:LocalUserOrGroupRsopSetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:BaseInstanceXml CLASSNAME="RSOP_PolmkrLocalUsersSetting">
            <q1:PROPERTY NAME="name">
              <q1:VALUE>Administrator (built-in)</q1:VALUE>
            </q1:PROPERTY>
            <q1:PROPERTY NAME="GPOID">
              <q1:VALUE>CN={31B2F340-016D-11D2-945F-00C04FB984F9},CN=Policies,CN=System,DC=TestDomain,DC=local</q1:VALUE>
            </q1:PROPERTY>
            <q1:PROPERTY NAME="SOMID">
              <q1:VALUE>DC=TestDomain,DC=local</q1:VALUE>
            </q1:PROPERTY>
            <q1:PROPERTY NAME="polmkrBaseGpeGuid">
              <q1:VALUE>{79F92669-4224-476c-9C5C-6EFB4D87DF4A}</q1:VALUE>
            </q1:PROPERTY>
            <q1:PROPERTY NAME="polmkrBaseCseGuid">
              <q1:VALUE>{17D89FEC-5C44-4972-B12D-241CAEF74509}</q1:VALUE>
            </q1:PROPERTY>
            <q1:PROPERTY NAME="polmkrBaseGpoDisplayName">
              <q1:VALUE>Default TestDomain Policy</q1:VALUE>
            </q1:PROPERTY>
            <q1:PROPERTY NAME="polmkrBaseGpoGuid">
              <q1:VALUE>{31B2F340-016D-11D2-945F-00C04FB984F9}</q1:VALUE>
            </q1:PROPERTY>
            <q1:PROPERTY NAME="id">
              <q1:VALUE>{6AF7EDD3-1203-42A7-8468-9A945A041CB8}</q1:VALUE>
            </q1:PROPERTY>
            <q1:PROPERTY NAME="precedence">
              <q1:VALUE>1</q1:VALUE>
            </q1:PROPERTY>
            <q1:PROPERTY NAME="creationTime">
              <q1:VALUE>20190111151632.271000+000</q1:VALUE>
            </q1:PROPERTY>
            <q1:PROPERTY NAME="polmkrBaseHash">
              <q1:VALUE>RSOP_PolmkrLocalUsersSetting.polmkrUserName="Administrator (built-in)"</q1:VALUE>
            </q1:PROPERTY>
            <q1:INSTANCE CLASSNAME="RSOP_PolmkrUserItem">
              <q1:PROPERTY NAME="polmkrClassClsid">
                <q1:VALUE>{DF5F1855-51E5-4d24-8B1A-D9BDE98BA1D1}</q1:VALUE>
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrClassName">
                <q1:VALUE>Administrator (built-in)</q1:VALUE>
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrClassImage">
                <q1:VALUE>2</q1:VALUE>
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrClassChanged">
                <q1:VALUE>2015-10-27 21:10:29</q1:VALUE>
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrClassUid">
                <q1:VALUE>{ADD38E1B-45C7-42AB-8BF0-4140756BEB40}</q1:VALUE>
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrAction">
                <q1:VALUE>U</q1:VALUE>
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrNewName">
                <q1:VALUE />
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrFullName">
                <q1:VALUE />
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrDescription">
                <q1:VALUE />
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrCpassword">
                <q1:VALUE />
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrChangeLogon">
                <q1:VALUE>0</q1:VALUE>
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrNoChange">
                <q1:VALUE>0</q1:VALUE>
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrNeverExpires">
                <q1:VALUE>0</q1:VALUE>
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrAcctDisabled">
                <q1:VALUE>0</q1:VALUE>
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrSubAuthority">
                <q1:VALUE>RID_ADMIN</q1:VALUE>
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrUserName">
                <q1:VALUE>Administrator (built-in)</q1:VALUE>
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrActionResolved">
                <q1:VALUE>U</q1:VALUE>
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrClassResultCodeValue">
                <q1:VALUE>0</q1:VALUE>
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrClassResultCode">
                <q1:VALUE>0x00000000</q1:VALUE>
              </q1:PROPERTY>
              <q1:PROPERTY NAME="polmkrClassResultText">
                <q1:VALUE>The operation completed successfully.</q1:VALUE>
              </q1:PROPERTY>
              <q1:Values />
              <q1:Attributes />
              <q1:Members />
            </q1:INSTANCE>
            <q1:Values />
            <q1:Attributes />
            <q1:Members />
          </q1:BaseInstanceXml>
        </q1:LocalUserOrGroupRsopSetting>
      </Extension>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Settings">Local Users and Groups</Name>
    </ExtensionData>
    <ExtensionData>
      <Extension xmlns:q2="http://www.microsoft.com/GroupPolicy/Settings/PrinterConnections" xsi:type="q2:PrinterConnectionSettings" xmlns="http://www.microsoft.com/GroupPolicy/Settings" />
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Settings">Deployed Printer Connections Policy</Name>
    </ExtensionData>
    <ExtensionData>
      <Extension xmlns:q3="http://www.microsoft.com/GroupPolicy/Settings/DriveMaps" xsi:type="q3:DriveMapSettings" xmlns="http://www.microsoft.com/GroupPolicy/Settings">
        <q3:DriveMapRsopSetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{44803AF6-5BB2-4103-8867-2CF6DB57AB0E}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q3:BaseInstanceXml CLASSNAME="RSOP_PolmkrDriveSetting">
            <q3:PROPERTY NAME="name">
              <q3:VALUE>X:</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="GPOID">
              <q3:VALUE>cn={44803AF6-5BB2-4103-8867-2CF6DB57AB0E},cn=policies,cn=system,DC=TestDomain,DC=local</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="SOMID">
              <q3:VALUE>DC=TestDomain,DC=local</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="polmkrBaseGpeGuid">
              <q3:VALUE>{2EA1A81B-48E5-45E9-8BB7-A6E3AC170006}</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="polmkrBaseCseGuid">
              <q3:VALUE>{5794DAFD-BE60-433f-88A2-1A31939AC01F}</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="polmkrBaseGpoDisplayName">
              <q3:VALUE>Map Drives</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="polmkrBaseGpoGuid">
              <q3:VALUE>{44803AF6-5BB2-4103-8867-2CF6DB57AB0E}</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="id">
              <q3:VALUE>{34E0CA0E-AC83-44C5-9E35-C887B4BA7313}</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="precedence">
              <q3:VALUE>1</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="creationTime">
              <q3:VALUE>20190111151632.521000+000</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="polmkrBaseHash">
              <q3:VALUE>RSOP_PolmkrDriveSetting.polmkrLetter="X"</q3:VALUE>
            </q3:PROPERTY>
            <q3:INSTANCE CLASSNAME="RSOP_PolmkrDriveItem">
              <q3:PROPERTY NAME="polmkrClassClsid">
                <q3:VALUE>{935D1B74-9CB8-4e3c-9914-7DD559B7A417}</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassName">
                <q3:VALUE>X:</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassStatus">
                <q3:VALUE>X:</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassImage">
                <q3:VALUE>0</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassChanged">
                <q3:VALUE>2018-08-01 16:59:53</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassUid">
                <q3:VALUE>{EA18971E-A57B-46D0-A431-94F6F27FB03F}</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassBypassErrors">
                <q3:VALUE>1</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrAction">
                <q3:VALUE>C</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrThisDrive">
                <q3:VALUE>NOCHANGE</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrAllDrives">
                <q3:VALUE>NOCHANGE</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrUserName">
                <q3:VALUE />
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrPath">
                <q3:VALUE>\\ServerName\documents</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrLabel">
                <q3:VALUE>Test Documents</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrPersistent">
                <q3:VALUE>1</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrUseLetter">
                <q3:VALUE>1</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrLetter">
                <q3:VALUE>X</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrActionResolved">
                <q3:VALUE>C</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrLetterResolved">
                <q3:VALUE>x:</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassResultCodeValue">
                <q3:VALUE>0</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassResultCode">
                <q3:VALUE>0x00000000</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassResultText">
                <q3:VALUE>The operation completed successfully.</q3:VALUE>
              </q3:PROPERTY>
              <q3:Values />
              <q3:Attributes />
              <q3:Members />
            </q3:INSTANCE>
            <q3:Values />
            <q3:Attributes />
            <q3:Members />
          </q3:BaseInstanceXml>
        </q3:DriveMapRsopSetting>
        <q3:DriveMapRsopSetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{44803AF6-5BB2-4103-8867-2CF6DB57AB0E}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">2</Precedence>
          <q3:BaseInstanceXml CLASSNAME="RSOP_PolmkrDriveSetting">
            <q3:PROPERTY NAME="name">
              <q3:VALUE>X:</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="GPOID">
              <q3:VALUE>cn={44803AF6-5BB2-4103-8867-2CF6DB57AB0E},cn=policies,cn=system,DC=TestDomain,DC=local</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="SOMID">
              <q3:VALUE>DC=TestDomain,DC=local</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="polmkrBaseGpeGuid">
              <q3:VALUE>{2EA1A81B-48E5-45E9-8BB7-A6E3AC170006}</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="polmkrBaseCseGuid">
              <q3:VALUE>{5794DAFD-BE60-433f-88A2-1A31939AC01F}</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="polmkrBaseGpoDisplayName">
              <q3:VALUE>Map Drives</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="polmkrBaseGpoGuid">
              <q3:VALUE>{44803AF6-5BB2-4103-8867-2CF6DB57AB0E}</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="id">
              <q3:VALUE>{F3D980BF-2849-469D-A6DC-216CF6DAE5C3}</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="precedence">
              <q3:VALUE>2</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="creationTime">
              <q3:VALUE>20190111151632.505000+000</q3:VALUE>
            </q3:PROPERTY>
            <q3:PROPERTY NAME="polmkrBaseHash">
              <q3:VALUE>RSOP_PolmkrDriveSetting.polmkrLetter="X"</q3:VALUE>
            </q3:PROPERTY>
            <q3:INSTANCE CLASSNAME="RSOP_PolmkrDriveItem">
              <q3:PROPERTY NAME="polmkrClassClsid">
                <q3:VALUE>{935D1B74-9CB8-4e3c-9914-7DD559B7A417}</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassName">
                <q3:VALUE>X:</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassStatus">
                <q3:VALUE>X:</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassImage">
                <q3:VALUE>3</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassChanged">
                <q3:VALUE>2018-08-01 17:00:17</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassUid">
                <q3:VALUE>{A91E922B-D8A4-41D3-B665-A23F43859B6B}</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrAction">
                <q3:VALUE>D</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrThisDrive">
                <q3:VALUE>NOCHANGE</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrAllDrives">
                <q3:VALUE>NOCHANGE</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrUserName">
                <q3:VALUE />
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrPath">
                <q3:VALUE />
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrLabel">
                <q3:VALUE />
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrPersistent">
                <q3:VALUE>0</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrUseLetter">
                <q3:VALUE>1</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrLetter">
                <q3:VALUE>X</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrActionResolved">
                <q3:VALUE>D</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrLetterResolved">
                <q3:VALUE>x:</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassResultCodeValue">
                <q3:VALUE>0</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassResultCode">
                <q3:VALUE>0x00000000</q3:VALUE>
              </q3:PROPERTY>
              <q3:PROPERTY NAME="polmkrClassResultText">
                <q3:VALUE>The operation completed successfully.</q3:VALUE>
              </q3:PROPERTY>
              <q3:Values />
              <q3:Attributes />
              <q3:Members />
            </q3:INSTANCE>
            <q3:Values />
            <q3:Attributes />
            <q3:Members />
          </q3:BaseInstanceXml>
        </q3:DriveMapRsopSetting>
      </Extension>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Settings">Drive Maps</Name>
    </ExtensionData>
    <ExtensionData>
      <Extension xmlns:q4="http://www.microsoft.com/GroupPolicy/Settings/Printers" xsi:type="q4:PrintersSettings" xmlns="http://www.microsoft.com/GroupPolicy/Settings">
        <q4:PrintersRsopSetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{B3E43407-D9FF-4202-A878-55E9D16703C7}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q4:BaseInstanceXml CLASSNAME="RSOP_PolmkrSharedPrinterSetting">
            <q4:PROPERTY NAME="name">
              <q4:VALUE>Monroe - Canon iR-ADV 6575</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="GPOID">
              <q4:VALUE>cn={B3E43407-D9FF-4202-A878-55E9D16703C7},cn=policies,cn=system,DC=TestDomain,DC=local</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="SOMID">
              <q4:VALUE>DC=TestDomain,DC=local</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseGpeGuid">
              <q4:VALUE>{A8C42CEA-CDB8-4388-97F4-5831F933DA84}</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseCseGuid">
              <q4:VALUE>{BC75B1ED-5833-4858-9BB8-CBF0B166DF9D}</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseGpoDisplayName">
              <q4:VALUE>Deploy Shared Printers</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseGpoGuid">
              <q4:VALUE>{B3E43407-D9FF-4202-A878-55E9D16703C7}</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="id">
              <q4:VALUE>{E07C9111-C6C4-4354-A2F4-665C1CFC0EA9}</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="precedence">
              <q4:VALUE>1</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="creationTime">
              <q4:VALUE>20190111151632.740000+000</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseHash">
              <q4:VALUE>RSOP_PolmkrSharedPrinterSetting.polmkrDeleteAll="0",polmkrPath="\\BODC01\Monroe - Canon iR-ADV 6575"</q4:VALUE>
            </q4:PROPERTY>
            <q4:INSTANCE CLASSNAME="RSOP_PolmkrSharedPrinterItem">
              <q4:PROPERTY NAME="polmkrClassClsid">
                <q4:VALUE>{9A5E9697-9095-436d-A0EE-4D128FDFBCE5}</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassName">
                <q4:VALUE>Monroe - Canon iR-ADV 6575</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassStatus">
                <q4:VALUE>Monroe - Canon iR-ADV 6575</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassImage">
                <q4:VALUE>2</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassChanged">
                <q4:VALUE>2018-09-20 18:35:26</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassUid">
                <q4:VALUE>{A510C50A-6F2D-4FA3-8418-6737AE5C0DF4}</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrAction">
                <q4:VALUE>U</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrComment">
                <q4:VALUE />
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrPath">
                <q4:VALUE>\\BODC01\Monroe - Canon iR-ADV 6575</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrLocation">
                <q4:VALUE />
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrDefault">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrSkipLocal">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrDeleteAll">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrPersistent">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrDeleteMaps">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrPort">
                <q4:VALUE />
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrActionResolved">
                <q4:VALUE>U</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassResultCodeValue">
                <q4:VALUE>-2147021884</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassResultCode">
                <q4:VALUE>0x80070bc4</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassResultText">
                <q4:VALUE>No printers were found.</q4:VALUE>
              </q4:PROPERTY>
              <q4:Values />
              <q4:Attributes />
              <q4:Members />
            </q4:INSTANCE>
            <q4:Values />
            <q4:Attributes />
            <q4:Members />
          </q4:BaseInstanceXml>
        </q4:PrintersRsopSetting>
        <q4:PrintersRsopSetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{B3E43407-D9FF-4202-A878-55E9D16703C7}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q4:BaseInstanceXml CLASSNAME="RSOP_PolmkrSharedPrinterSetting">
            <q4:PROPERTY NAME="name">
              <q4:VALUE>MFC-8810-BO-ComputerRoom</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="GPOID">
              <q4:VALUE>cn={B3E43407-D9FF-4202-A878-55E9D16703C7},cn=policies,cn=system,DC=TestDomain,DC=local</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="SOMID">
              <q4:VALUE>DC=TestDomain,DC=local</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseGpeGuid">
              <q4:VALUE>{A8C42CEA-CDB8-4388-97F4-5831F933DA84}</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseCseGuid">
              <q4:VALUE>{BC75B1ED-5833-4858-9BB8-CBF0B166DF9D}</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseGpoDisplayName">
              <q4:VALUE>Deploy Shared Printers</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseGpoGuid">
              <q4:VALUE>{B3E43407-D9FF-4202-A878-55E9D16703C7}</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="id">
              <q4:VALUE>{BE5ABD0E-28AC-4F4A-9FA7-6B1C0FA6A210}</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="precedence">
              <q4:VALUE>1</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="creationTime">
              <q4:VALUE>20190111151636.521000+000</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseHash">
              <q4:VALUE>RSOP_PolmkrSharedPrinterSetting.polmkrDeleteAll="0",polmkrPath="\\BODC01\MFC-8810-BO-ComputerRoom"</q4:VALUE>
            </q4:PROPERTY>
            <q4:INSTANCE CLASSNAME="RSOP_PolmkrSharedPrinterItem">
              <q4:PROPERTY NAME="polmkrClassClsid">
                <q4:VALUE>{9A5E9697-9095-436d-A0EE-4D128FDFBCE5}</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassName">
                <q4:VALUE>MFC-8810-BO-ComputerRoom</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassStatus">
                <q4:VALUE>MFC-8810-BO-ComputerRoom</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassImage">
                <q4:VALUE>2</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassChanged">
                <q4:VALUE>2018-10-09 15:36:20</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassUid">
                <q4:VALUE>{5CE5D8AE-B0AB-496E-81B1-6A8D3A3C9B4E}</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrAction">
                <q4:VALUE>U</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrComment">
                <q4:VALUE />
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrPath">
                <q4:VALUE>\\BODC01\MFC-8810-BO-ComputerRoom</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrLocation">
                <q4:VALUE />
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrDefault">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrSkipLocal">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrDeleteAll">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrPersistent">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrDeleteMaps">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrPort">
                <q4:VALUE />
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrActionResolved">
                <q4:VALUE>U</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassResultCodeValue">
                <q4:VALUE>-2147024886</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassResultCode">
                <q4:VALUE>0x8007000a</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassResultText">
                <q4:VALUE>The environment is incorrect.</q4:VALUE>
              </q4:PROPERTY>
              <q4:Values />
              <q4:Attributes />
              <q4:Members />
            </q4:INSTANCE>
            <q4:Values />
            <q4:Attributes />
            <q4:Members />
          </q4:BaseInstanceXml>
        </q4:PrintersRsopSetting>
        <q4:PrintersRsopSetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{B3E43407-D9FF-4202-A878-55E9D16703C7}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q4:BaseInstanceXml CLASSNAME="RSOP_PolmkrSharedPrinterSetting">
            <q4:PROPERTY NAME="name">
              <q4:VALUE>Hp Test HQ computerroom</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="GPOID">
              <q4:VALUE>cn={B3E43407-D9FF-4202-A878-55E9D16703C7},cn=policies,cn=system,DC=TestDomain,DC=local</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="SOMID">
              <q4:VALUE>DC=TestDomain,DC=local</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseGpeGuid">
              <q4:VALUE>{A8C42CEA-CDB8-4388-97F4-5831F933DA84}</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseCseGuid">
              <q4:VALUE>{BC75B1ED-5833-4858-9BB8-CBF0B166DF9D}</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseGpoDisplayName">
              <q4:VALUE>Deploy Shared Printers</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseGpoGuid">
              <q4:VALUE>{B3E43407-D9FF-4202-A878-55E9D16703C7}</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="id">
              <q4:VALUE>{648A9A72-D04F-48EC-868C-80F019BDB88D}</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="precedence">
              <q4:VALUE>1</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="creationTime">
              <q4:VALUE>20190111151636.521000+000</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseHash">
              <q4:VALUE>RSOP_PolmkrSharedPrinterSetting.polmkrDeleteAll="0",polmkrPath="\\ServerName\Hp Test HQ computerroom"</q4:VALUE>
            </q4:PROPERTY>
            <q4:INSTANCE CLASSNAME="RSOP_PolmkrSharedPrinterItem">
              <q4:PROPERTY NAME="polmkrClassClsid">
                <q4:VALUE>{9A5E9697-9095-436d-A0EE-4D128FDFBCE5}</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassName">
                <q4:VALUE>Hp Test HQ computerroom</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassStatus">
                <q4:VALUE>Hp Test HQ computerroom</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassImage">
                <q4:VALUE>2</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassChanged">
                <q4:VALUE>2018-09-21 14:54:38</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassUid">
                <q4:VALUE>{5B1C1148-C8D6-4D44-9771-048F1B6ADC19}</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrAction">
                <q4:VALUE>U</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrComment">
                <q4:VALUE />
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrPath">
                <q4:VALUE>\\ServerName\Hp Test HQ computerroom</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrLocation">
                <q4:VALUE />
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrDefault">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrSkipLocal">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrDeleteAll">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrPersistent">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrDeleteMaps">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrPort">
                <q4:VALUE />
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrActionResolved">
                <q4:VALUE>U</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassResultCodeValue">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassResultCode">
                <q4:VALUE>0x00000000</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassResultText">
                <q4:VALUE>The operation completed successfully.</q4:VALUE>
              </q4:PROPERTY>
              <q4:Values />
              <q4:Attributes />
              <q4:Members />
            </q4:INSTANCE>
            <q4:Values />
            <q4:Attributes />
            <q4:Members />
          </q4:BaseInstanceXml>
        </q4:PrintersRsopSetting>
        <q4:PrintersRsopSetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{B3E43407-D9FF-4202-A878-55E9D16703C7}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q4:BaseInstanceXml CLASSNAME="RSOP_PolmkrSharedPrinterSetting">
            <q4:PROPERTY NAME="name">
              <q4:VALUE>TestSite Staff - iR-ADV 6575</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="GPOID">
              <q4:VALUE>cn={B3E43407-D9FF-4202-A878-55E9D16703C7},cn=policies,cn=system,DC=TestDomain,DC=local</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="SOMID">
              <q4:VALUE>DC=TestDomain,DC=local</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseGpeGuid">
              <q4:VALUE>{A8C42CEA-CDB8-4388-97F4-5831F933DA84}</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseCseGuid">
              <q4:VALUE>{BC75B1ED-5833-4858-9BB8-CBF0B166DF9D}</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseGpoDisplayName">
              <q4:VALUE>Deploy Shared Printers</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseGpoGuid">
              <q4:VALUE>{B3E43407-D9FF-4202-A878-55E9D16703C7}</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="id">
              <q4:VALUE>{0D459A1B-D9C1-4ABC-BE2D-0D3D50A4BA95}</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="precedence">
              <q4:VALUE>1</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="creationTime">
              <q4:VALUE>20190111151634.036000+000</q4:VALUE>
            </q4:PROPERTY>
            <q4:PROPERTY NAME="polmkrBaseHash">
              <q4:VALUE>RSOP_PolmkrSharedPrinterSetting.polmkrDeleteAll="0",polmkrPath="\\ServerName\TestSite Staff - iR-ADV 6575"</q4:VALUE>
            </q4:PROPERTY>
            <q4:INSTANCE CLASSNAME="RSOP_PolmkrSharedPrinterItem">
              <q4:PROPERTY NAME="polmkrClassClsid">
                <q4:VALUE>{9A5E9697-9095-436d-A0EE-4D128FDFBCE5}</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassName">
                <q4:VALUE>TestSite Staff - iR-ADV 6575</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassStatus">
                <q4:VALUE>TestSite Staff - iR-ADV 6575</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassImage">
                <q4:VALUE>2</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassChanged">
                <q4:VALUE>2018-09-21 14:36:42</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassUid">
                <q4:VALUE>{80C55B9D-6C6B-4408-9650-B3E5461A36FB}</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrAction">
                <q4:VALUE>U</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrComment">
                <q4:VALUE />
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrPath">
                <q4:VALUE>\\ServerName\TestSite Staff - iR-ADV 6575</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrLocation">
                <q4:VALUE />
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrDefault">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrSkipLocal">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrDeleteAll">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrPersistent">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrDeleteMaps">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrPort">
                <q4:VALUE />
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrActionResolved">
                <q4:VALUE>U</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassResultCodeValue">
                <q4:VALUE>0</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassResultCode">
                <q4:VALUE>0x00000000</q4:VALUE>
              </q4:PROPERTY>
              <q4:PROPERTY NAME="polmkrClassResultText">
                <q4:VALUE>The operation completed successfully.</q4:VALUE>
              </q4:PROPERTY>
              <q4:Values />
              <q4:Attributes />
              <q4:Members />
            </q4:INSTANCE>
            <q4:Values />
            <q4:Attributes />
            <q4:Members />
          </q4:BaseInstanceXml>
        </q4:PrintersRsopSetting>
      </Extension>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Settings">Printers</Name>
    </ExtensionData>
    <ExtensionData>
      <Extension xmlns:q5="http://www.microsoft.com/GroupPolicy/Settings/FolderRedirection" xsi:type="q5:FolderRedirectionSettings" xmlns="http://www.microsoft.com/GroupPolicy/Settings">
        <q5:Folder>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{028FC632-2F46-4C50-B725-6A15C97CD7AA}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q5:Id>{FDD39AD0-238F-46AF-ADB4-6C85480369C7}</q5:Id>
          <q5:Location>
            <q5:DestinationPath>\\ServerName\Users\Administrator\My Documents</q5:DestinationPath>
            <q5:SecurityGroup>
              <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">s-1-1-0</SID>
              <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Everyone</Name>
            </q5:SecurityGroup>
          </q5:Location>
          <q5:GrantExclusiveRights>false</q5:GrantExclusiveRights>
          <q5:MoveContents>true</q5:MoveContents>
          <q5:FollowParent>false</q5:FollowParent>
          <q5:ApplyToDownLevel>false</q5:ApplyToDownLevel>
          <q5:DoNotCare>false</q5:DoNotCare>
          <q5:RedirectToLocal>false</q5:RedirectToLocal>
          <q5:PolicyRemovalBehavior>LeaveContents</q5:PolicyRemovalBehavior>
          <q5:ConfigurationControl>GP</q5:ConfigurationControl>
          <q5:PrimaryComputerEvaluation>PrimaryComputerPolicyDisabled</q5:PrimaryComputerEvaluation>
        </q5:Folder>
        <q5:Folder>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{028FC632-2F46-4C50-B725-6A15C97CD7AA}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q5:Id>{1777F761-68AD-4D8A-87BD-30B759FA33DD}</q5:Id>
          <q5:Location>
            <q5:DestinationPath>\\ServerName\users\Administrator\Favorites</q5:DestinationPath>
            <q5:SecurityGroup>
              <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">s-1-1-0</SID>
              <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Everyone</Name>
            </q5:SecurityGroup>
          </q5:Location>
          <q5:GrantExclusiveRights>false</q5:GrantExclusiveRights>
          <q5:MoveContents>false</q5:MoveContents>
          <q5:FollowParent>false</q5:FollowParent>
          <q5:ApplyToDownLevel>false</q5:ApplyToDownLevel>
          <q5:DoNotCare>false</q5:DoNotCare>
          <q5:RedirectToLocal>false</q5:RedirectToLocal>
          <q5:PolicyRemovalBehavior>LeaveContents</q5:PolicyRemovalBehavior>
          <q5:ConfigurationControl>GP</q5:ConfigurationControl>
          <q5:PrimaryComputerEvaluation>PrimaryComputerPolicyDisabled</q5:PrimaryComputerEvaluation>
        </q5:Folder>
        <q5:Folder>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{028FC632-2F46-4C50-B725-6A15C97CD7AA}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q5:Id>{4BD8D571-6D19-48D3-BE97-422220080E43}</q5:Id>
          <q5:Location>
            <q5:DestinationPath>\\ServerName\Users\Administrator\Music</q5:DestinationPath>
            <q5:SecurityGroup>
              <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">s-1-1-0</SID>
              <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Everyone</Name>
            </q5:SecurityGroup>
          </q5:Location>
          <q5:GrantExclusiveRights>false</q5:GrantExclusiveRights>
          <q5:MoveContents>false</q5:MoveContents>
          <q5:FollowParent>false</q5:FollowParent>
          <q5:ApplyToDownLevel>false</q5:ApplyToDownLevel>
          <q5:DoNotCare>false</q5:DoNotCare>
          <q5:RedirectToLocal>false</q5:RedirectToLocal>
          <q5:PolicyRemovalBehavior>LeaveContents</q5:PolicyRemovalBehavior>
          <q5:ConfigurationControl>GP</q5:ConfigurationControl>
          <q5:PrimaryComputerEvaluation>PrimaryComputerPolicyDisabled</q5:PrimaryComputerEvaluation>
        </q5:Folder>
        <q5:Folder>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{028FC632-2F46-4C50-B725-6A15C97CD7AA}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q5:Id>{18989B1D-99B5-455B-841C-AB7C74E4DDFC}</q5:Id>
          <q5:Location>
            <q5:DestinationPath>\\ServerName\Users\Administrator\Videos</q5:DestinationPath>
            <q5:SecurityGroup>
              <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">s-1-1-0</SID>
              <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Everyone</Name>
            </q5:SecurityGroup>
          </q5:Location>
          <q5:GrantExclusiveRights>false</q5:GrantExclusiveRights>
          <q5:MoveContents>false</q5:MoveContents>
          <q5:FollowParent>false</q5:FollowParent>
          <q5:ApplyToDownLevel>false</q5:ApplyToDownLevel>
          <q5:DoNotCare>false</q5:DoNotCare>
          <q5:RedirectToLocal>false</q5:RedirectToLocal>
          <q5:PolicyRemovalBehavior>LeaveContents</q5:PolicyRemovalBehavior>
          <q5:ConfigurationControl>GP</q5:ConfigurationControl>
          <q5:PrimaryComputerEvaluation>PrimaryComputerPolicyDisabled</q5:PrimaryComputerEvaluation>
        </q5:Folder>
        <q5:Folder>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{028FC632-2F46-4C50-B725-6A15C97CD7AA}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q5:Id>{33E28130-4E1E-4676-835A-98395C3BC3BB}</q5:Id>
          <q5:Location>
            <q5:DestinationPath>\\ServerName\Users\Administrator\My Pictures</q5:DestinationPath>
            <q5:SecurityGroup>
              <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">s-1-1-0</SID>
              <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Everyone</Name>
            </q5:SecurityGroup>
          </q5:Location>
          <q5:GrantExclusiveRights>false</q5:GrantExclusiveRights>
          <q5:MoveContents>false</q5:MoveContents>
          <q5:FollowParent>false</q5:FollowParent>
          <q5:ApplyToDownLevel>true</q5:ApplyToDownLevel>
          <q5:DoNotCare>false</q5:DoNotCare>
          <q5:RedirectToLocal>false</q5:RedirectToLocal>
          <q5:PolicyRemovalBehavior>LeaveContents</q5:PolicyRemovalBehavior>
          <q5:ConfigurationControl>GP</q5:ConfigurationControl>
          <q5:PrimaryComputerEvaluation>PrimaryComputerPolicyDisabled</q5:PrimaryComputerEvaluation>
        </q5:Folder>
      </Extension>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Settings">Folder Redirection</Name>
    </ExtensionData>
    <ExtensionData>
      <Extension xmlns:q6="http://www.microsoft.com/GroupPolicy/Settings/Registry" xsi:type="q6:RegistrySettings" xmlns="http://www.microsoft.com/GroupPolicy/Settings">
        <q6:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q6:Name>Enable screen saver</q6:Name>
          <q6:State>Enabled</q6:State>
          <q6:Explain>Enables desktop screen savers.

If you disable this setting, screen savers do not run. Also, this setting disables the Screen Saver section of the Screen Saver dialog in the Personalization or Display Control Panel. As a result, users cannot change the screen saver options.

If you do not configure it, this setting has no effect on the system.

If you enable it, a screen saver runs, provided the following two conditions hold: First, a valid screen saver on the client is specified through the "Screen Saver executable name" setting or through Control Panel on the client computer. Second, the screen saver timeout is set to a nonzero value through the setting or Control Panel.

Also, see the "Prevent changing Screen Saver" setting.</q6:Explain>
          <q6:Supported>At least Windows 2000 Service Pack 1</q6:Supported>
          <q6:Category>Control Panel/Personalization</q6:Category>
        </q6:Policy>
        <q6:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q6:Name>Password protect the screen saver</q6:Name>
          <q6:State>Enabled</q6:State>
          <q6:Explain>Determines whether screen savers used on the computer are password protected.

If you enable this setting, all screen savers are password protected. If you disable this setting, password protection cannot be set on any screen saver.

This setting also disables the "Password protected" checkbox on the Screen Saver dialog in the Personalization or Display Control Panel, preventing users from changing the password protection setting.

If you do not configure this setting, users can choose whether or not to set password protection on each screen saver.

To ensure that a computer will be password protected, enable the "Enable Screen Saver" setting and specify a timeout via the "Screen Saver timeout" setting.

Note: To remove the Screen Saver dialog, use the "Prevent changing Screen Saver" setting.</q6:Explain>
          <q6:Supported>At least Windows 2000 Service Pack 1</q6:Supported>
          <q6:Category>Control Panel/Personalization</q6:Category>
        </q6:Policy>
        <q6:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q6:Name>Screen saver timeout</q6:Name>
          <q6:State>Enabled</q6:State>
          <q6:Explain>Specifies how much user idle time must elapse before the screen saver is launched.

When configured, this idle time can be set from a minimum of 1 second to a maximum of 86,400 seconds, or 24 hours. If set to zero, the screen saver will not be started.

This setting has no effect under any of the following circumstances:

    - The setting is disabled or not configured.

    - The wait time is set to zero.

    - The "Enable Screen Saver" setting is disabled.

    - Neither the "Screen saver executable name" setting nor the Screen Saver dialog of the client computer's Personalization or Display Control Panel specifies a valid existing screen saver program on the client.

When not configured, whatever wait time is set on the client through the Screen Saver dialog in the Personalization or Display Control Panel is used. The default is 15 minutes.</q6:Explain>
          <q6:Supported>At least Windows 2000 Service Pack 1</q6:Supported>
          <q6:Category>Control Panel/Personalization</q6:Category>
          <q6:Text>
            <q6:Name>Number of seconds to wait to enable the screen saver</q6:Name>
          </q6:Text>
          <q6:Text>
            <q6:Name> </q6:Name>
          </q6:Text>
          <q6:Numeric>
            <q6:Name>Seconds:</q6:Name>
            <q6:State>Enabled</q6:State>
            <q6:Value>1800</q6:Value>
          </q6:Numeric>
        </q6:Policy>
        <q6:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q6:Name>Package Point and print - Approved servers</q6:Name>
          <q6:State>Enabled</q6:State>
          <q6:Explain>Restricts package point and print to approved servers.

This policy setting restricts package point and print connections to approved servers. This setting only applies to Package Point and Print connections, and is completely independent from the "Point and Print Restrictions" policy that governs the behavior of non-package point and print connections.

Windows Vista and later clients will attempt to make a non-package point and print connection anytime a package point and print connection fails, including attempts that are blocked by this policy. Administrators may need to set both policies to block all print connections to a specific print server.

If this setting is enabled, users will only be able to package point and print to print servers approved by the network administrator. When using package point and print, client computers will check the driver signature of all drivers that are downloaded from print servers.

If this setting is disabled, or not configured, package point and print will not be restricted to specific print servers.</q6:Explain>
          <q6:Supported>Windows Server 2008 and Windows Vista</q6:Supported>
          <q6:Category>Control Panel/Printers</q6:Category>
          <q6:ListBox>
            <q6:Name>Enter fully qualified server names</q6:Name>
            <q6:State>Enabled</q6:State>
            <q6:ExplicitValue>false</q6:ExplicitValue>
            <q6:Additive>true</q6:Additive>
            <q6:Value>
              <q6:Element>
                <q6:Data>ServerName.TestDomain.Local</q6:Data>
              </q6:Element>
              <q6:Element>
                <q6:Data>ServerName</q6:Data>
              </q6:Element>
            </q6:Value>
          </q6:ListBox>
        </q6:Policy>
        <q6:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q6:Name>Point and Print Restrictions</q6:Name>
          <q6:State>Enabled</q6:State>
          <q6:Explain>This policy setting controls the client Point and Print behavior, including the security prompts for Windows Vista computers. The policy setting applies only to non-Print Administrator clients, and only to computers that are members of a TestDomain.

          If you enable this policy setting:
          -Windows XP and later clients will only download print driver components from a list of explicitly named servers. If a compatible print driver is available on the client, a printer connection will be made. If a compatible print driver is not available on the client, no connection will be made.
          -You can configure Windows Vista clients so that security warnings and elevated command prompts do not appear when users Point and Print, or when printer connection drivers need to be updated.

          If you do not configure this policy setting:
          -Windows Vista client computers can point and print to any server.
          -Windows Vista computers will show a warning and an elevated command prompt when users create a printer connection to any server using Point and Print.
          -Windows Vista computers will show a warning and an elevated command prompt when an existing printer connection driver needs to be updated.
          -Windows Server 2003 and Windows XP client computers can create a printer connection to any server in their forest using Point and Print.

          If you disable this policy setting:
          -Windows Vista client computers can create a printer connection to any server using Point and Print.
          -Windows Vista computers will not show a warning or an elevated command prompt when users create a printer connection to any server using Point and Print.
          -Windows Vista computers will not show a warning or an elevated command prompt when an existing printer connection driver needs to be updated.
          -Windows Server 2003 and Windows XP client computers can create a printer connection to any server using Point and Print.
          -The "Users can only point and print to computers in their forest" setting applies only to Windows Server 2003 and Windows XP SP1 (and later service packs).</q6:Explain>
          <q6:Supported>Supported Windows XP SP1 through Windows Server 2008 RTM</q6:Supported>
          <q6:Category>Control Panel/Printers</q6:Category>
          <q6:CheckBox>
            <q6:Name>Users can only point and print to these servers:</q6:Name>
            <q6:State>Disabled</q6:State>
          </q6:CheckBox>
          <q6:EditText>
            <q6:Name>Enter fully qualified server names separated by semicolons</q6:Name>
            <q6:State>Enabled</q6:State>
            <q6:Value />
          </q6:EditText>
          <q6:CheckBox>
            <q6:Name>Users can only point and print to machines in their forest</q6:Name>
            <q6:State>Disabled</q6:State>
          </q6:CheckBox>
          <q6:Text>
            <q6:Name />
          </q6:Text>
          <q6:Text>
            <q6:Name>Security Prompts:</q6:Name>
          </q6:Text>
          <q6:DropDownList>
            <q6:Name>When installing drivers for a new connection:</q6:Name>
            <q6:State>Enabled</q6:State>
            <q6:Value>
              <q6:Name>Do not show warning or elevation prompt</q6:Name>
            </q6:Value>
          </q6:DropDownList>
          <q6:DropDownList>
            <q6:Name>When updating drivers for an existing connection:</q6:Name>
            <q6:State>Enabled</q6:State>
            <q6:Value>
              <q6:Name>Show warning and elevation prompt</q6:Name>
            </q6:Value>
          </q6:DropDownList>
          <q6:Text>
            <q6:Name>This setting only applies to:</q6:Name>
          </q6:Text>
          <q6:Text>
            <q6:Name>Windows Vista and later</q6:Name>
          </q6:Text>
        </q6:Policy>
        <q6:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q6:Name>Exclude directories in roaming profile</q6:Name>
          <q6:State>Enabled</q6:State>
          <q6:Explain>This policy setting lets you exclude folders that are normally included in the user's profile. As a result, these folders do not need to be stored by the network server on which the profile resides and do not follow users to other computers.

Note: When excluding content from the profile you should try to exclude the narrowest set of data that will address your needs. For example, if there is one application with data that should not be roamed then add only that application's specific folder under the AppData\Roaming folder rather than all of the AppData\Roaming folder to the exclusion list.

By default, the Appdata\Local and Appdata\LocalLow folders and all their subfolders such as the History, Temp, and Temporary Internet Files folders are excluded from the user's roaming profile.

In operating systems earlier than Microsoft Windows Vista, only the History, Local Settings, Temp, and Temporary Internet Files folders are excluded from the user's roaming profile by default.

If you enable this policy setting, you can exclude additional folders.

If you disable this policy setting or do not configure it, only the default folders are excluded.

Note: You cannot use this policy setting to include the default folders in a roaming user profile.</q6:Explain>
          <q6:Supported>At least Windows 2000</q6:Supported>
          <q6:Category>System/User Profiles</q6:Category>
          <q6:EditText>
            <q6:Name>Prevent the following directories from roaming with the profile:</q6:Name>
            <q6:State>Enabled</q6:State>
            <q6:Value>WhatsApp;Google\Chrome\User Data\Profile\PepperFlash;DropBox;</q6:Value>
          </q6:EditText>
          <q6:Text>
            <q6:Name>You can enter multiple directory names, semi-colon separated,</q6:Name>
          </q6:Text>
          <q6:Text>
            <q6:Name>all relative to the root of the user's profile</q6:Name>
          </q6:Text>
        </q6:Policy>
        <q6:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q6:Name>Set user data directory</q6:Name>
          <q6:State>Enabled</q6:State>
          <q6:Explain>Configures the directory that Google Chrome will use for storing user data.\n\nIf you set this policy, Google Chrome will use the provided directory regardless whether the user has specified the '--user-data-dir' flag or not.\n\nSee http://www.chromium.org/administrators/policy-list-3/user-data-directory-variables for a list of variables that can be used.\n\nIf this policy is left not set the default profile path will be used and the user will be able to override it with the '--user-data-dir' command line flag.</q6:Explain>
          <q6:Supported>Microsoft Windows XP SP2 or later</q6:Supported>
          <q6:Category>Google/Google Chrome</q6:Category>
          <q6:EditText>
            <q6:Name>Set user data directory</q6:Name>
            <q6:State>Enabled</q6:State>
            <q6:Value>${roaming_app_data}\Google\Chrome\User Data\Profile</q6:Value>
          </q6:EditText>
        </q6:Policy>
        <q6:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q6:KeyPath>Software\Policies\Microsoft\Windows\Control Panel\Desktop</q6:KeyPath>
          <q6:AdmSetting>false</q6:AdmSetting>
        </q6:RegistrySetting>
        <q6:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q6:KeyPath>Software\Policies\Microsoft\Windows\System</q6:KeyPath>
          <q6:AdmSetting>false</q6:AdmSetting>
        </q6:RegistrySetting>
        <q6:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q6:KeyPath>Software\Policies\Microsoft\Windows NT\Printers\PackagePointAndPrint</q6:KeyPath>
          <q6:AdmSetting>false</q6:AdmSetting>
        </q6:RegistrySetting>
        <q6:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q6:KeyPath>Software\Policies\Microsoft\Windows NT\Printers\PackagePointAndPrint\ListofServers</q6:KeyPath>
          <q6:AdmSetting>false</q6:AdmSetting>
        </q6:RegistrySetting>
        <q6:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q6:KeyPath>Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint</q6:KeyPath>
          <q6:AdmSetting>false</q6:AdmSetting>
        </q6:RegistrySetting>
        <q6:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q6:KeyPath>Software\Policies\Google\Chrome</q6:KeyPath>
          <q6:AdmSetting>false</q6:AdmSetting>
        </q6:RegistrySetting>
      </Extension>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Settings">Registry</Name>
    </ExtensionData>
    <EventsDetails>
      <SinglePassEventsDetails ActivityId="{7e2f6b85-5a7a-4044-9cb5-e997f391f2c6}" ProcessingTrigger="Periodic" ProcessingAppMode="Background" LinkSpeedInKbps="742264" SlowLinkThresholdInKbps="500" TestDomainControllerName="TestAD1.TestDomain.Local" TestDomainControllerIPAddress="200.200.200.250" PolicyProcessingMode="None" PolicyElapsedTimeInMilliseconds="16093" ErrorCount="0" WarningCount="0">
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4007&lt;/EventID&gt;&lt;Version&gt;1&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;1&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.386223800Z'/&gt;&lt;EventRecordID&gt;2183047&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PolicyActivityId'&gt;{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}&lt;/Data&gt;&lt;Data Name='PrincipalSamName'&gt;TestDomain\TestUser&lt;/Data&gt;&lt;Data Name='IsMachine'&gt;0&lt;/Data&gt;&lt;Data Name='IsTestDomainJoined'&gt;true&lt;/Data&gt;&lt;Data Name='IsBackgroundProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsAsyncProcessing'&gt;false&lt;/Data&gt;&lt;Data Name='IsServiceRestart'&gt;false&lt;/Data&gt;&lt;Data Name='ReasonForSyncProcessing'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Starting periodic policy processing for user TestDomain\TestUser.
Activity id: {7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5340&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.386223800Z'/&gt;&lt;EventRecordID&gt;2183048&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PolicyApplicationMode'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The Group Policy processing mode is Background.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.386223800Z'/&gt;&lt;EventRecordID&gt;2183049&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4114&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Attempting to retrieve the account information.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.386223800Z'/&gt;&lt;EventRecordID&gt;2183050&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4117&lt;/Data&gt;&lt;Data Name='Parameter'&gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system call to get account information.
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.386223800Z'/&gt;&lt;EventRecordID&gt;2183051&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4118&lt;/Data&gt;&lt;Data Name='Parameter'&gt;CN=Administrator,CN=Users,DC=TestDomain,DC=local&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system call to get account information completed.
CN=Administrator,CN=Users,DC=TestDomain,DC=local
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.386223800Z'/&gt;&lt;EventRecordID&gt;2183052&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4115&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Retrieved account information.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4326&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.386223800Z'/&gt;&lt;EventRecordID&gt;2183053&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Group Policy is trying to discover the TestDomain Controller information.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.386223800Z'/&gt;&lt;EventRecordID&gt;2183054&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4096&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Retrieving TestDomain Controller details.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.698714800Z'/&gt;&lt;EventRecordID&gt;2183055&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4119&lt;/Data&gt;&lt;Data Name='Parameter'&gt;TestAD1.TestDomain.Local&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making LDAP calls to connect and bind to Active Directory.
TestAD1.TestDomain.Local</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.698714800Z'/&gt;&lt;EventRecordID&gt;2183056&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4120&lt;/Data&gt;&lt;Data Name='Parameter'&gt;TestAD1.TestDomain.Local&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The LDAP call to connect and bind to Active Directory completed.
TestAD1.TestDomain.Local
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5308&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.698714800Z'/&gt;&lt;EventRecordID&gt;2183057&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='DCName'&gt;TestAD1.TestDomain.Local&lt;/Data&gt;&lt;Data Name='DCIPAddress'&gt;200.200.200.250&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>TestDomain Controller details:
	TestDomain Controller Name : TestAD1.TestDomain.Local
	TestDomain Controller IP Address : 200.200.200.250</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5326&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.698714800Z'/&gt;&lt;EventRecordID&gt;2183058&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='DCDiscoveryTimeInMilliSeconds'&gt;313&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Group Policy successfully discovered the TestDomain Controller in 313 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5309&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.698714800Z'/&gt;&lt;EventRecordID&gt;2183059&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='MachineRole'&gt;2&lt;/Data&gt;&lt;Data Name='NetworkName'&gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Computer details:
	Computer role : 2
	Network name : </EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5310&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.698714800Z'/&gt;&lt;EventRecordID&gt;2183060&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PrincipalCNName'&gt;CN=Administrator,CN=Users,DC=TestDomain,DC=local&lt;/Data&gt;&lt;Data Name='PrincipalTestDomainName'&gt;TestDomain.Local&lt;/Data&gt;&lt;Data Name='DCName'&gt;\\TestAD1.TestDomain.Local&lt;/Data&gt;&lt;Data Name='DCTestDomainName'&gt;TestDomain.Local&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Account details:
	Account Name : CN=Administrator,CN=Users,DC=TestDomain,DC=local
	Account TestDomain Name : TestDomain.Local
	DC Name : \\TestAD1.TestDomain.Local
	DC TestDomain Name : TestDomain.Local</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5311&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.823750100Z'/&gt;&lt;EventRecordID&gt;2183061&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PolicyProcessingMode'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The loopback policy processing mode is "No loopback mode".</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4126&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.823750100Z'/&gt;&lt;EventRecordID&gt;2183062&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='IsMachine'&gt;false&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Group Policy receiving applicable GPOs from the TestDomain controller.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4257&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:57.823750100Z'/&gt;&lt;EventRecordID&gt;2183063&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='IsMachine'&gt;false&lt;/Data&gt;&lt;Data Name='IsBackgroundProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsAsyncProcessing'&gt;true&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Starting to download policies.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5327&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.245599900Z'/&gt;&lt;EventRecordID&gt;2183064&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='NetworkBandwidthInKbps'&gt;92783088&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Estimated network bandwidth on one of the connections: 92783088 kbps.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5314&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.245599900Z'/&gt;&lt;EventRecordID&gt;2183065&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='BandwidthInkbps'&gt;742264&lt;/Data&gt;&lt;Data Name='IsSlowLink'&gt;false&lt;/Data&gt;&lt;Data Name='ThresholdInkbps'&gt;500&lt;/Data&gt;&lt;Data Name='PolicyApplicationMode'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='LinkDescription'&gt;%%4113&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>A fast link was detected. The Estimated bandwidth is 742264 kbps. The slow link threshold is 500 kbps.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.245599900Z'/&gt;&lt;EventRecordID&gt;2183066&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.261211500Z'/&gt;&lt;EventRecordID&gt;2183067&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;16&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\gpt.ini
The call completed in 16 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.261211500Z'/&gt;&lt;EventRecordID&gt;2183068&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{0D58CEF2-7134-4F34-AF14-4CB943DB1879}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{0D58CEF2-7134-4F34-AF14-4CB943DB1879}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.261211500Z'/&gt;&lt;EventRecordID&gt;2183069&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{0D58CEF2-7134-4F34-AF14-4CB943DB1879}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{0D58CEF2-7134-4F34-AF14-4CB943DB1879}\gpt.ini
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.261211500Z'/&gt;&lt;EventRecordID&gt;2183070&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{B3E43407-D9FF-4202-A878-55E9D16703C7}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{B3E43407-D9FF-4202-A878-55E9D16703C7}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.261211500Z'/&gt;&lt;EventRecordID&gt;2183071&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{B3E43407-D9FF-4202-A878-55E9D16703C7}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{B3E43407-D9FF-4202-A878-55E9D16703C7}\gpt.ini
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.261211500Z'/&gt;&lt;EventRecordID&gt;2183072&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{44803AF6-5BB2-4103-8867-2CF6DB57AB0E}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{44803AF6-5BB2-4103-8867-2CF6DB57AB0E}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.261211500Z'/&gt;&lt;EventRecordID&gt;2183073&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{44803AF6-5BB2-4103-8867-2CF6DB57AB0E}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{44803AF6-5BB2-4103-8867-2CF6DB57AB0E}\gpt.ini
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.261211500Z'/&gt;&lt;EventRecordID&gt;2183074&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{028FC632-2F46-4C50-B725-6A15C97CD7AA}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{028FC632-2F46-4C50-B725-6A15C97CD7AA}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.276831900Z'/&gt;&lt;EventRecordID&gt;2183075&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;16&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{028FC632-2F46-4C50-B725-6A15C97CD7AA}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{028FC632-2F46-4C50-B725-6A15C97CD7AA}\gpt.ini
The call completed in 16 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.276831900Z'/&gt;&lt;EventRecordID&gt;2183076&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.276831900Z'/&gt;&lt;EventRecordID&gt;2183077&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}\gpt.ini
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5257&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.276831900Z'/&gt;&lt;EventRecordID&gt;2183078&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='IsMachine'&gt;false&lt;/Data&gt;&lt;Data Name='PolicyDownloadTimeElapsedInMilliseconds'&gt;453&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Successfully completed downloading policies.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5126&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.276831900Z'/&gt;&lt;EventRecordID&gt;2183079&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='IsMachine'&gt;true&lt;/Data&gt;&lt;Data Name='IsBackgroundProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsAsyncProcessing'&gt;false&lt;/Data&gt;&lt;Data Name='NumberOfGPOsDownloaded'&gt;6&lt;/Data&gt;&lt;Data Name='NumberOfGPOsApplicable'&gt;0&lt;/Data&gt;&lt;Data Name='GPODownloadTimeElapsedInMilliseconds'&gt;453&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Group Policy successfully got applicable GPOs from the TestDomain controller.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5312&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.276831900Z'/&gt;&lt;EventRecordID&gt;2183080&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='DescriptionString'&gt;Deploy Shared Printers
Map Drives
Test HomeDir
Set Point&amp;amp;Print Settings
Default TestDomain Policy
Desktop Redirection
&lt;/Data&gt;&lt;Data Name='GPOInfoList'&gt;&amp;lt;GPO ID="{B3E43407-D9FF-4202-A878-55E9D16703C7}"&amp;gt;&amp;lt;Name&amp;gt;Deploy Shared Printers&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;1703962&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{B3E43407-D9FF-4202-A878-55E9D16703C7}\User&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{00000000-0000-0000-0000-000000000000}{A8C42CEA-CDB8-4388-97F4-5831F933DA84}][{BC75B1ED-5833-4858-9BB8-CBF0B166DF9D}{A8C42CEA-CDB8-4388-97F4-5831F933DA84}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{44803AF6-5BB2-4103-8867-2CF6DB57AB0E}"&amp;gt;&amp;lt;Name&amp;gt;Map Drives&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;917518&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{44803AF6-5BB2-4103-8867-2CF6DB57AB0E}\User&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{00000000-0000-0000-0000-000000000000}{2EA1A81B-48E5-45E9-8BB7-A6E3AC170006}][{5794DAFD-BE60-433F-88A2-1A31939AC01F}{2EA1A81B-48E5-45E9-8BB7-A6E3AC170006}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{028FC632-2F46-4C50-B725-6A15C97CD7AA}"&amp;gt;&amp;lt;Name&amp;gt;Test HomeDir&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;3342387&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{028FC632-2F46-4C50-B725-6A15C97CD7AA}\User&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{25537BA6-77A8-11D2-9B6C-0000F8080861}{88E729D6-BDC1-11D1-BD2A-00C04FB9603F}][{8A28E2C5-8D06-49A4-A08C-632DAA493E17}{CC13E3F3-D6D7-4A7C-A806-085502AA8281}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}"&amp;gt;&amp;lt;Name&amp;gt;Set Point&amp;amp;Print Settings&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;196611&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}\User&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F73-3407-48AE-BA88-E8213C6761F1}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{31B2F340-016D-11D2-945F-00C04FB984F9}"&amp;gt;&amp;lt;Name&amp;gt;Default TestDomain Policy&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;1048592&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\User&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{00000000-0000-0000-0000-000000000000}{79F92669-4224-476C-9C5C-6EFB4D87DF4A}][{17D89FEC-5C44-4972-B12D-241CAEF74509}{79F92669-4224-476C-9C5C-6EFB4D87DF4A}][{3060E8D0-7020-11D2-842D-00C04FA372D4}{3060E8CE-7020-11D2-842D-00C04FA372D4}][{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F73-3407-48AE-BA88-E8213C6761F1}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{0D58CEF2-7134-4F34-AF14-4CB943DB1879}"&amp;gt;&amp;lt;Name&amp;gt;Desktop Redirection&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;393222&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://CN=TestSite,CN=Sites,CN=Configuration,DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{0D58CEF2-7134-4F34-AF14-4CB943DB1879}\User&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{25537BA6-77A8-11D2-9B6C-0000F8080861}{88E729D6-BDC1-11D1-BD2A-00C04FB9603F}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>List of applicable Group Policy objects:

Deploy Shared Printers
Map Drives
Test HomeDir
Set Point&amp;Print Settings
Default TestDomain Policy
Desktop Redirection
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5313&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.276831900Z'/&gt;&lt;EventRecordID&gt;2183081&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='DescriptionString'&gt;Local Group Policy
	Not Applied (Empty)
&lt;/Data&gt;&lt;Data Name='GPOInfoList'&gt;&amp;lt;GPO ID="Local Group Policy"&amp;gt;&amp;lt;Name&amp;gt;Local Group Policy&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;0&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;Local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;C:\Windows\System32\GroupPolicy\User&amp;lt;/FSPath&amp;gt;&amp;lt;Reason&amp;gt;NOTAPPLIED-EMPTY&amp;lt;/Reason&amp;gt;&amp;lt;/GPO&amp;gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The following Group Policy objects were not applicable because they were filtered out :

Local Group Policy
	Not Applied (Empty)
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.276831900Z'/&gt;&lt;EventRecordID&gt;2183082&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4161&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Checking for Group Policy client extensions that are not part of the system.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.276831900Z'/&gt;&lt;EventRecordID&gt;2183083&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4163&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Service configuration update to standalone is not required and will be skipped.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.276831900Z'/&gt;&lt;EventRecordID&gt;2183084&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4165&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Finished checking for non-system extensions.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4016&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;1&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.292458200Z'/&gt;&lt;EventRecordID&gt;2183085&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='CSEExtensionId'&gt;{17D89FEC-5C44-4972-B12D-241CAEF74509}&lt;/Data&gt;&lt;Data Name='CSEExtensionName'&gt;Group Policy Local Users and Groups&lt;/Data&gt;&lt;Data Name='IsExtensionAsyncProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsGPOListChanged'&gt;false&lt;/Data&gt;&lt;Data Name='GPOListStatusString'&gt;%%4101&lt;/Data&gt;&lt;Data Name='DescriptionString'&gt;Default TestDomain Policy
&lt;/Data&gt;&lt;Data Name='ApplicableGPOList'&gt;&amp;lt;GPO ID="{31B2F340-016D-11D2-945F-00C04FB984F9}"&amp;gt;&amp;lt;Name&amp;gt;Default TestDomain Policy&amp;lt;/Name&amp;gt;&amp;lt;/GPO&amp;gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Starting Group Policy Local Users and Groups Extension Processing.

List of applicable Group Policy objects: (No changes were detected.)

Default TestDomain Policy
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5016&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;2&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.745727700Z'/&gt;&lt;EventRecordID&gt;2183086&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='CSEElaspedTimeInMilliSeconds'&gt;453&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='CSEExtensionName'&gt;Group Policy Local Users and Groups&lt;/Data&gt;&lt;Data Name='CSEExtensionId'&gt;{17D89FEC-5C44-4972-B12D-241CAEF74509}&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Completed Group Policy Local Users and Groups Extension Processing in 453 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4016&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;1&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.761202900Z'/&gt;&lt;EventRecordID&gt;2183087&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='CSEExtensionId'&gt;{25537BA6-77A8-11D2-9B6C-0000F8080861}&lt;/Data&gt;&lt;Data Name='CSEExtensionName'&gt;Folder Redirection&lt;/Data&gt;&lt;Data Name='IsExtensionAsyncProcessing'&gt;false&lt;/Data&gt;&lt;Data Name='IsGPOListChanged'&gt;false&lt;/Data&gt;&lt;Data Name='GPOListStatusString'&gt;%%4101&lt;/Data&gt;&lt;Data Name='DescriptionString'&gt;Test HomeDir
Desktop Redirection
&lt;/Data&gt;&lt;Data Name='ApplicableGPOList'&gt;&amp;lt;GPO ID="{028FC632-2F46-4C50-B725-6A15C97CD7AA}"&amp;gt;&amp;lt;Name&amp;gt;Test HomeDir&amp;lt;/Name&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{0D58CEF2-7134-4F34-AF14-4CB943DB1879}"&amp;gt;&amp;lt;Name&amp;gt;Desktop Redirection&amp;lt;/Name&amp;gt;&amp;lt;/GPO&amp;gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Starting Folder Redirection Extension Processing.

List of applicable Group Policy objects: (No changes were detected.)

Test HomeDir
Desktop Redirection
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5016&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;2&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.823704300Z'/&gt;&lt;EventRecordID&gt;2183088&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='CSEElaspedTimeInMilliSeconds'&gt;63&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='CSEExtensionName'&gt;Folder Redirection&lt;/Data&gt;&lt;Data Name='CSEExtensionId'&gt;{25537BA6-77A8-11D2-9B6C-0000F8080861}&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Completed Folder Redirection Extension Processing in 63 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4016&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;1&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:58.854954900Z'/&gt;&lt;EventRecordID&gt;2183089&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='CSEExtensionId'&gt;{5794DAFD-BE60-433F-88A2-1A31939AC01F}&lt;/Data&gt;&lt;Data Name='CSEExtensionName'&gt;Group Policy Drive Maps&lt;/Data&gt;&lt;Data Name='IsExtensionAsyncProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsGPOListChanged'&gt;false&lt;/Data&gt;&lt;Data Name='GPOListStatusString'&gt;%%4101&lt;/Data&gt;&lt;Data Name='DescriptionString'&gt;Map Drives
&lt;/Data&gt;&lt;Data Name='ApplicableGPOList'&gt;&amp;lt;GPO ID="{44803AF6-5BB2-4103-8867-2CF6DB57AB0E}"&amp;gt;&amp;lt;Name&amp;gt;Map Drives&amp;lt;/Name&amp;gt;&amp;lt;/GPO&amp;gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Starting Group Policy Drive Maps Extension Processing.

List of applicable Group Policy objects: (No changes were detected.)

Map Drives
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5016&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;2&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:59.245582600Z'/&gt;&lt;EventRecordID&gt;2183090&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='CSEElaspedTimeInMilliSeconds'&gt;390&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='CSEExtensionName'&gt;Group Policy Drive Maps&lt;/Data&gt;&lt;Data Name='CSEExtensionId'&gt;{5794DAFD-BE60-433F-88A2-1A31939AC01F}&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Completed Group Policy Drive Maps Extension Processing in 390 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4016&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;1&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:59.261203300Z'/&gt;&lt;EventRecordID&gt;2183091&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='CSEExtensionId'&gt;{8A28E2C5-8D06-49A4-A08C-632DAA493E17}&lt;/Data&gt;&lt;Data Name='CSEExtensionName'&gt;Deployed Printer Connections&lt;/Data&gt;&lt;Data Name='IsExtensionAsyncProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsGPOListChanged'&gt;false&lt;/Data&gt;&lt;Data Name='GPOListStatusString'&gt;%%4101&lt;/Data&gt;&lt;Data Name='DescriptionString'&gt;Test HomeDir
&lt;/Data&gt;&lt;Data Name='ApplicableGPOList'&gt;&amp;lt;GPO ID="{028FC632-2F46-4C50-B725-6A15C97CD7AA}"&amp;gt;&amp;lt;Name&amp;gt;Test HomeDir&amp;lt;/Name&amp;gt;&amp;lt;/GPO&amp;gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Starting Deployed Printer Connections Extension Processing.

List of applicable Group Policy objects: (No changes were detected.)

Test HomeDir
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5016&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;2&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:59.276828600Z'/&gt;&lt;EventRecordID&gt;2183092&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='CSEElaspedTimeInMilliSeconds'&gt;16&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='CSEExtensionName'&gt;Deployed Printer Connections&lt;/Data&gt;&lt;Data Name='CSEExtensionId'&gt;{8A28E2C5-8D06-49A4-A08C-632DAA493E17}&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Completed Deployed Printer Connections Extension Processing in 16 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4016&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;1&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:49:59.276828600Z'/&gt;&lt;EventRecordID&gt;2183093&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='CSEExtensionId'&gt;{BC75B1ED-5833-4858-9BB8-CBF0B166DF9D}&lt;/Data&gt;&lt;Data Name='CSEExtensionName'&gt;Group Policy Printers&lt;/Data&gt;&lt;Data Name='IsExtensionAsyncProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsGPOListChanged'&gt;false&lt;/Data&gt;&lt;Data Name='GPOListStatusString'&gt;%%4101&lt;/Data&gt;&lt;Data Name='DescriptionString'&gt;Deploy Shared Printers
&lt;/Data&gt;&lt;Data Name='ApplicableGPOList'&gt;&amp;lt;GPO ID="{B3E43407-D9FF-4202-A878-55E9D16703C7}"&amp;gt;&amp;lt;Name&amp;gt;Deploy Shared Printers&amp;lt;/Name&amp;gt;&amp;lt;/GPO&amp;gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Starting Group Policy Printers Extension Processing.

List of applicable Group Policy objects: (No changes were detected.)

Deploy Shared Printers
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5016&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;2&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:50:13.479955200Z'/&gt;&lt;EventRecordID&gt;2183094&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='CSEElaspedTimeInMilliSeconds'&gt;14203&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='CSEExtensionName'&gt;Group Policy Printers&lt;/Data&gt;&lt;Data Name='CSEExtensionId'&gt;{BC75B1ED-5833-4858-9BB8-CBF0B166DF9D}&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Completed Group Policy Printers Extension Processing in 14203 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;8007&lt;/EventID&gt;&lt;Version&gt;1&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;2&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:50:13.479955200Z'/&gt;&lt;EventRecordID&gt;2183095&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PolicyElaspedTimeInSeconds'&gt;16&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='PrincipalSamName'&gt;TestDomain\TestUser&lt;/Data&gt;&lt;Data Name='IsMachine'&gt;0&lt;/Data&gt;&lt;Data Name='IsConnectivityFailure'&gt;false&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Completed periodic policy processing for user TestDomain\TestUser in 16 seconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5315&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:50:13.479955200Z'/&gt;&lt;EventRecordID&gt;2183096&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{7E2F6B85-5A7A-4044-9CB5-E997F391F2C6}'/&gt;&lt;Execution ProcessID='720' ThreadID='6388'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PrincipalSamName'&gt;TestDomain\TestUser&lt;/Data&gt;&lt;Data Name='NextPolicyApplicationTime'&gt;115&lt;/Data&gt;&lt;Data Name='NextPolicyApplicationTimeUnit'&gt;%%4100&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Next policy processing for TestDomain\TestUser will be attempted in 115 minutes.</EventDescription>
        </EventRecord>
        <ExtensionProcessingTime>
          <ExtensionName>Group Policy Local Users and Groups</ExtensionName>
          <ExtensionGuid>{17D89FEC-5C44-4972-B12D-241CAEF74509}</ExtensionGuid>
          <ElapsedTimeInMilliseconds>453</ElapsedTimeInMilliseconds>
          <ProcessedTimeStamp>2019-01-14T11:49:58.7457277-05:00</ProcessedTimeStamp>
        </ExtensionProcessingTime>
        <ExtensionProcessingTime>
          <ExtensionName>Folder Redirection</ExtensionName>
          <ExtensionGuid>{25537BA6-77A8-11D2-9B6C-0000F8080861}</ExtensionGuid>
          <ElapsedTimeInMilliseconds>63</ElapsedTimeInMilliseconds>
          <ProcessedTimeStamp>2019-01-14T11:49:58.8237043-05:00</ProcessedTimeStamp>
        </ExtensionProcessingTime>
        <ExtensionProcessingTime>
          <ExtensionName>Group Policy Drive Maps</ExtensionName>
          <ExtensionGuid>{5794DAFD-BE60-433F-88A2-1A31939AC01F}</ExtensionGuid>
          <ElapsedTimeInMilliseconds>390</ElapsedTimeInMilliseconds>
          <ProcessedTimeStamp>2019-01-14T11:49:59.2455826-05:00</ProcessedTimeStamp>
        </ExtensionProcessingTime>
        <ExtensionProcessingTime>
          <ExtensionName>Deployed Printer Connections</ExtensionName>
          <ExtensionGuid>{8A28E2C5-8D06-49A4-A08C-632DAA493E17}</ExtensionGuid>
          <ElapsedTimeInMilliseconds>16</ElapsedTimeInMilliseconds>
          <ProcessedTimeStamp>2019-01-14T11:49:59.2768286-05:00</ProcessedTimeStamp>
        </ExtensionProcessingTime>
        <ExtensionProcessingTime>
          <ExtensionName>Group Policy Printers</ExtensionName>
          <ExtensionGuid>{BC75B1ED-5833-4858-9BB8-CBF0B166DF9D}</ExtensionGuid>
          <ElapsedTimeInMilliseconds>14203</ElapsedTimeInMilliseconds>
          <ProcessedTimeStamp>2019-01-14T11:50:13.4799552-05:00</ProcessedTimeStamp>
        </ExtensionProcessingTime>
        <ExtensionProcessingTime>
          <ExtensionName>Group Policy Infrastructure</ExtensionName>
          <ExtensionGuid>{00000000-0000-0000-0000-000000000000}</ExtensionGuid>
          <ElapsedTimeInMilliseconds>968</ElapsedTimeInMilliseconds>
          <ProcessedTimeStamp>2019-01-14T11:50:13.4799552-05:00</ProcessedTimeStamp>
        </ExtensionProcessingTime>
      </SinglePassEventsDetails>
    </EventsDetails>
  </UserResults>
  <ComputerResults>
    <Version>2228228</Version>
    <Name>TestDomain\TestSQL$</Name>
    <TestDomain>TestDomain.Local</TestDomain>
    <SOM>TestDomain.Local/Servers</SOM>
    <Site>TestSite</Site>
    <SearchedSOM>
      <Path>Local</Path>
      <Type>Local</Type>
      <Order>1</Order>
      <BlocksInheritance>false</BlocksInheritance>
      <Blocked>false</Blocked>
      <Reason>Normal</Reason>
    </SearchedSOM>
    <SearchedSOM>
      <Path>TestDomain.Local/Servers</Path>
      <Type>OU</Type>
      <Order>4</Order>
      <BlocksInheritance>false</BlocksInheritance>
      <Blocked>false</Blocked>
      <Reason>Normal</Reason>
    </SearchedSOM>
    <SearchedSOM>
      <Path>TestDomain.Local</Path>
      <Type>TestDomain</Type>
      <Order>3</Order>
      <BlocksInheritance>false</BlocksInheritance>
      <Blocked>false</Blocked>
      <Reason>Normal</Reason>
    </SearchedSOM>
    <SearchedSOM>
      <Path>TestDomain.Local/Configuration/Sites/TestSite</Path>
      <Type>Site</Type>
      <Order>2</Order>
      <BlocksInheritance>false</BlocksInheritance>
      <Blocked>false</Blocked>
      <Reason>Normal</Reason>
    </SearchedSOM>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-32-544</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">BUILTIN\Administrators</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-1-0</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Everyone</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-2973276235-1234567891-1002</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestSQL\SQLServerMSSQLServerADHelperUser$TestSQL</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-2973276235-1234567891-1017</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestSQL\SophosUser</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-32-545</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">BUILTIN\Users</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-2</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT AUTHORITY\NETWORK</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-11</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT AUTHORITY\Authenticated Users</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-15</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT AUTHORITY\This Organization</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-7482</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\TestSQL$</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-515</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\TestDomain Computers</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-18-1</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Authentication authority asserted identity</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-16-16384</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Mandatory Label\System Mandatory Level</Name>
    </SecurityGroup>
    <SlowLink>false</SlowLink>
    <ExtensionStatus>
      <Name>Group Policy Infrastructure</Name>
      <Identifier>{00000000-0000-0000-0000-000000000000}</Identifier>
      <BeginTime>2019-01-14T16:14:25</BeginTime>
      <EndTime>2019-01-14T16:14:27</EndTime>
      <LoggingStatus>Complete</LoggingStatus>
      <Error>0</Error>
    </ExtensionStatus>
    <ExtensionStatus>
      <Name>Registry</Name>
      <Identifier>{35378EAC-683F-11D2-A89A-00C04FBBCFA2}</Identifier>
      <BeginTime>2019-01-07T21:54:05</BeginTime>
      <EndTime>2019-01-07T21:54:06</EndTime>
      <LoggingStatus>Complete</LoggingStatus>
      <Error>0</Error>
    </ExtensionStatus>
    <ExtensionStatus>
      <Name>Scripts</Name>
      <Identifier>{42B5FAAE-6536-11d2-AE5A-0000F87571E3}</Identifier>
      <BeginTime>2018-11-16T19:04:32</BeginTime>
      <EndTime>2018-11-16T19:04:32</EndTime>
      <LoggingStatus>Complete</LoggingStatus>
      <Error>0</Error>
    </ExtensionStatus>
    <ExtensionStatus>
      <Name>Group Policy Services</Name>
      <Identifier>{91FBB303-0CD5-4055-BF42-E512A681B325}</Identifier>
      <BeginTime>2019-01-11T16:32:26</BeginTime>
      <EndTime>2019-01-14T16:14:27</EndTime>
      <LoggingStatus>Complete</LoggingStatus>
      <Error>0</Error>
    </ExtensionStatus>
    <ExtensionStatus>
      <Name>Security</Name>
      <Identifier>{827D319E-6EAC-11D2-A4EA-00C04F79F83A}</Identifier>
      <BeginTime>2018-12-25T23:11:24</BeginTime>
      <EndTime>2018-12-25T23:11:26</EndTime>
      <LoggingStatus>Complete</LoggingStatus>
      <Error>0</Error>
    </ExtensionStatus>
    <GPO>
      <Name>Deploy WP</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8D1AA99C-242E-4FB5-B424-F8032A5FAAD8}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>7</VersionDirectory>
      <VersionSysvol>7</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>3</SOMOrder>
        <AppliedOrder>2</AppliedOrder>
        <LinkOrder>5</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>Scripts</ExtensionName>
    </GPO>
    <GPO>
      <Name>{EB1292B0-4693-453D-BC73-A7E9E3A90B28}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{EB1292B0-4693-453D-BC73-A7E9E3A90B28}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>11</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>13</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>{0D58CEF2-7134-4F34-AF14-4CB943DB1879}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{0D58CEF2-7134-4F34-AF14-4CB943DB1879}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local/Configuration/Sites/TestSite</SOMPath>
        <SOMOrder>1</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>2</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>true</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>Deploy Meshimer Certificate</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{401E1247-8143-425E-8D36-E5B53546D0A6}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>2</VersionDirectory>
      <VersionSysvol>2</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>9</SOMOrder>
        <AppliedOrder>6</AppliedOrder>
        <LinkOrder>11</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>{B1BE8D72-6EAC-11D2-A4EA-00C04F79F83A}</ExtensionName>
      <ExtensionName>Registry</ExtensionName>
    </GPO>
    <GPO>
      <Name>Set Point&amp;Print Settings</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>1</VersionDirectory>
      <VersionSysvol>1</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>14</SOMOrder>
        <AppliedOrder>7</AppliedOrder>
        <LinkOrder>16</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>Registry</ExtensionName>
    </GPO>
    <GPO>
      <Name>BitLocker</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{48C91754-D454-4371-A96D-7D699FF79E39}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>13</VersionDirectory>
      <VersionSysvol>13</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>16</SOMOrder>
        <AppliedOrder>9</AppliedOrder>
        <LinkOrder>18</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>Security</ExtensionName>
      <ExtensionName>Registry</ExtensionName>
    </GPO>
    <GPO>
      <Name>{D351D153-5F0B-43FA-9221-4C3153B7E8F6}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{D351D153-5F0B-43FA-9221-4C3153B7E8F6}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>8</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>10</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>QB Fix/Permissions</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{9C94FC30-D9D9-49F5-9683-37A7AA6CCBF4}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>13</VersionDirectory>
      <VersionSysvol>13</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>15</SOMOrder>
        <AppliedOrder>8</AppliedOrder>
        <LinkOrder>17</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>Security</ExtensionName>
      <ExtensionName>Scripts</ExtensionName>
      <ExtensionName>Registry</ExtensionName>
    </GPO>
    <GPO>
      <Name>Deploy Compu K Agent</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{108C814F-EF5F-43F0-98E3-24D28CC31E49}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>7</VersionDirectory>
      <VersionSysvol>7</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>1</SOMOrder>
        <AppliedOrder>10</AppliedOrder>
        <LinkOrder>3</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>true</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>Scripts</ExtensionName>
    </GPO>
    <GPO>
      <Name>Sophos Deployment</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{0C123D08-E7BC-4060-93B2-9A7CB029FCF6}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>2</VersionDirectory>
      <VersionSysvol>2</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>7</SOMOrder>
        <AppliedOrder>5</AppliedOrder>
        <LinkOrder>9</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>Scripts</ExtensionName>
    </GPO>
    <GPO>
      <Name>Enable Windows Firewall</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>100</VersionDirectory>
      <VersionSysvol>100</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>6</SOMOrder>
        <AppliedOrder>4</AppliedOrder>
        <LinkOrder>8</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>Registry</ExtensionName>
    </GPO>
    <GPO>
      <Name>{44803AF6-5BB2-4103-8867-2CF6DB57AB0E}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{44803AF6-5BB2-4103-8867-2CF6DB57AB0E}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>4</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>6</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>Default TestDomain Policy</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>122</VersionDirectory>
      <VersionSysvol>122</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>17</SOMOrder>
        <AppliedOrder>12</AppliedOrder>
        <LinkOrder>19</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>true</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>{C631DF4C-088F-4156-B058-4375F0853CD8}</ExtensionName>
      <ExtensionName>{B1BE8D72-6EAC-11D2-A4EA-00C04F79F83A}</ExtensionName>
      <ExtensionName>Group Policy Services</ExtensionName>
      <ExtensionName>Security</ExtensionName>
      <ExtensionName>Registry</ExtensionName>
      <ExtensionName>Group Policy Infrastructure</ExtensionName>
    </GPO>
    <GPO>
      <Name>Test HomeDir</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{028FC632-2F46-4C50-B725-6A15C97CD7AA}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>7</VersionDirectory>
      <VersionSysvol>65535</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>true</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>13</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>15</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <SecurityFilter>TestDomain\Test Employees</SecurityFilter>
      <ExtensionName>Security</ExtensionName>
    </GPO>
    <GPO>
      <Name>Local Group Policy</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">LocalGPO</Identifier>
      </Path>
      <VersionDirectory>5</VersionDirectory>
      <VersionSysvol>5</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>Local</SOMPath>
        <SOMOrder>1</SOMOrder>
        <AppliedOrder>1</AppliedOrder>
        <LinkOrder>1</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <ExtensionName>Registry</ExtensionName>
    </GPO>
    <GPO>
      <Name>{985715F9-9911-415E-973A-B4A2EEFB38AB}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{985715F9-9911-415E-973A-B4A2EEFB38AB}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>12</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>14</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>Remote Desktop</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D45E698-90BC-4C88-9EF4-0840082C5D0B}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>7</VersionDirectory>
      <VersionSysvol>7</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>10</SOMOrder>
        <AppliedOrder>11</AppliedOrder>
        <LinkOrder>12</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>true</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>Security</ExtensionName>
      <ExtensionName>Registry</ExtensionName>
    </GPO>
    <GPO>
      <Name>{B3E43407-D9FF-4202-A878-55E9D16703C7}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{B3E43407-D9FF-4202-A878-55E9D16703C7}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>0</VersionDirectory>
      <VersionSysvol>0</VersionSysvol>
      <IsValid>false</IsValid>
      <FilterAllowed>false</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>2</SOMOrder>
        <AppliedOrder>0</AppliedOrder>
        <LinkOrder>4</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>Deploy FCI K Agent</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{E7CCD934-0AB0-4B37-B71C-ADAC9923E8BD}</Identifier>
        <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
      </Path>
      <VersionDirectory>5</VersionDirectory>
      <VersionSysvol>5</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>5</SOMOrder>
        <AppliedOrder>3</AppliedOrder>
        <LinkOrder>7</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>Scripts</ExtensionName>
    </GPO>
    <ExtensionData>
      <Extension xmlns:q7="http://www.microsoft.com/GroupPolicy/Settings/Scripts" xsi:type="q7:Scripts" xmlns="http://www.microsoft.com/GroupPolicy/Settings">
        <q7:Script>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8D1AA99C-242E-4FB5-B424-F8032A5FAAD8}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q7:Command>\\TestDomain.Local\NETLOGON\WP-install.cmd</q7:Command>
          <q7:Parameters />
          <q7:Type>Startup</q7:Type>
          <q7:Order>0</q7:Order>
          <q7:RunOrder>PSNotConfigured</q7:RunOrder>
        </q7:Script>
        <q7:Script>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{E7CCD934-0AB0-4B37-B71C-ADAC9923E8BD}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q7:Command>\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{E7CCD934-0AB0-4B37-B71C-ADAC9923E8BD}\Machine\Scripts\Startup\KcsSetup.exe</q7:Command>
          <q7:Parameters />
          <q7:Type>Startup</q7:Type>
          <q7:Order>1</q7:Order>
          <q7:RunOrder>PSNotConfigured</q7:RunOrder>
        </q7:Script>
        <q7:Script>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{0C123D08-E7BC-4060-93B2-9A7CB029FCF6}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q7:Command>\\TestDomain.Local\NETLOGON\SophosInstall.cmd</q7:Command>
          <q7:Parameters />
          <q7:Type>Startup</q7:Type>
          <q7:Order>2</q7:Order>
          <q7:RunOrder>PSNotConfigured</q7:RunOrder>
        </q7:Script>
        <q7:Script>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{9C94FC30-D9D9-49F5-9683-37A7AA6CCBF4}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q7:Command>QBFix.cmd</q7:Command>
          <q7:Parameters />
          <q7:Type>Startup</q7:Type>
          <q7:Order>3</q7:Order>
          <q7:RunOrder>PSNotConfigured</q7:RunOrder>
        </q7:Script>
        <q7:Script>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{108C814F-EF5F-43F0-98E3-24D28CC31E49}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q7:Command>\\TestDomain.Local\NETLOGON\CompuSolutionsAgent.exe</q7:Command>
          <q7:Parameters />
          <q7:Type>Startup</q7:Type>
          <q7:Order>4</q7:Order>
          <q7:RunOrder>PSNotConfigured</q7:RunOrder>
        </q7:Script>
      </Extension>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Settings">Scripts</Name>
    </ExtensionData>
    <ExtensionData>
      <Extension xmlns:q8="http://www.microsoft.com/GroupPolicy/Settings/Services" xsi:type="q8:ServiceSettings" xmlns="http://www.microsoft.com/GroupPolicy/Settings">
        <q8:ServiceRsopSettings>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q8:BaseInstanceXml CLASSNAME="RSOP_PolmkrNtServiceSetting">
            <q8:PROPERTY NAME="name">
              <q8:VALUE>SSDPSRV</q8:VALUE>
            </q8:PROPERTY>
            <q8:PROPERTY NAME="GPOID">
              <q8:VALUE>CN={31B2F340-016D-11D2-945F-00C04FB984F9},CN=Policies,CN=System,DC=TestDomain,DC=local</q8:VALUE>
            </q8:PROPERTY>
            <q8:PROPERTY NAME="SOMID">
              <q8:VALUE>DC=TestDomain,DC=local</q8:VALUE>
            </q8:PROPERTY>
            <q8:PROPERTY NAME="polmkrBaseGpeGuid">
              <q8:VALUE>{CC5746A9-9B74-4be5-AE2E-64379C86E0E4}</q8:VALUE>
            </q8:PROPERTY>
            <q8:PROPERTY NAME="polmkrBaseCseGuid">
              <q8:VALUE>{91FBB303-0CD5-4055-BF42-E512A681B325}</q8:VALUE>
            </q8:PROPERTY>
            <q8:PROPERTY NAME="polmkrBaseGpoDisplayName">
              <q8:VALUE>Default TestDomain Policy</q8:VALUE>
            </q8:PROPERTY>
            <q8:PROPERTY NAME="polmkrBaseGpoGuid">
              <q8:VALUE>{31B2F340-016D-11D2-945F-00C04FB984F9}</q8:VALUE>
            </q8:PROPERTY>
            <q8:PROPERTY NAME="id">
              <q8:VALUE>{9383EACE-12A2-4927-A4DC-D5E508BBACCB}</q8:VALUE>
            </q8:PROPERTY>
            <q8:PROPERTY NAME="precedence">
              <q8:VALUE>1</q8:VALUE>
            </q8:PROPERTY>
            <q8:PROPERTY NAME="creationTime">
              <q8:VALUE>20190111163226.224000+000</q8:VALUE>
            </q8:PROPERTY>
            <q8:PROPERTY NAME="polmkrBaseHash">
              <q8:VALUE>RSOP_PolmkrNtServiceSetting.polmkrServiceName="SSDPSRV"</q8:VALUE>
            </q8:PROPERTY>
            <q8:INSTANCE CLASSNAME="RSOP_PolmkrNtServiceItem">
              <q8:PROPERTY NAME="polmkrClassClsid">
                <q8:VALUE>{AB6F0B67-341F-4e51-92F9-005FBFBA1A43}</q8:VALUE>
              </q8:PROPERTY>
              <q8:PROPERTY NAME="polmkrClassName">
                <q8:VALUE>SSDPSRV</q8:VALUE>
              </q8:PROPERTY>
              <q8:PROPERTY NAME="polmkrClassImage">
                <q8:VALUE>4</q8:VALUE>
              </q8:PROPERTY>
              <q8:PROPERTY NAME="polmkrClassChanged">
                <q8:VALUE>2015-11-19 18:39:56</q8:VALUE>
              </q8:PROPERTY>
              <q8:PROPERTY NAME="polmkrClassUid">
                <q8:VALUE>{35AEEE78-F562-4874-BAD9-0E3C2F09AE5A}</q8:VALUE>
              </q8:PROPERTY>
              <q8:PROPERTY NAME="polmkrStartupType">
                <q8:VALUE>DISABLED</q8:VALUE>
              </q8:PROPERTY>
              <q8:PROPERTY NAME="polmkrServiceName">
                <q8:VALUE>SSDPSRV</q8:VALUE>
              </q8:PROPERTY>
              <q8:PROPERTY NAME="polmkrServiceAction">
                <q8:VALUE>STOP</q8:VALUE>
              </q8:PROPERTY>
              <q8:PROPERTY NAME="polmkrTimeout">
                <q8:VALUE>30</q8:VALUE>
              </q8:PROPERTY>
              <q8:PROPERTY NAME="polmkrActionResolved">
                <q8:VALUE>U</q8:VALUE>
              </q8:PROPERTY>
              <q8:PROPERTY NAME="polmkrClassResultCodeValue">
                <q8:VALUE>0</q8:VALUE>
              </q8:PROPERTY>
              <q8:PROPERTY NAME="polmkrClassResultCode">
                <q8:VALUE>0x00000000</q8:VALUE>
              </q8:PROPERTY>
              <q8:PROPERTY NAME="polmkrClassResultText">
                <q8:VALUE>The operation completed successfully.</q8:VALUE>
              </q8:PROPERTY>
              <q8:Values />
              <q8:Attributes />
              <q8:Members />
            </q8:INSTANCE>
            <q8:Values />
            <q8:Attributes />
            <q8:Members />
          </q8:BaseInstanceXml>
        </q8:ServiceRsopSettings>
      </Extension>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Settings">Services</Name>
    </ExtensionData>
    <ExtensionData>
      <Extension xmlns:q9="http://www.microsoft.com/GroupPolicy/Settings/Security" xsi:type="q9:SecuritySettings" xmlns="http://www.microsoft.com/GroupPolicy/Settings">
        <q9:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:Name>LockoutDuration</q9:Name>
          <q9:SettingNumber>30</q9:SettingNumber>
          <q9:Type>Account Lockout</q9:Type>
        </q9:Account>
        <q9:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:Name>MaximumPasswordAge</q9:Name>
          <q9:SettingNumber>180</q9:SettingNumber>
          <q9:Type>Password</q9:Type>
        </q9:Account>
        <q9:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:Name>MinimumPasswordAge</q9:Name>
          <q9:SettingNumber>0</q9:SettingNumber>
          <q9:Type>Password</q9:Type>
        </q9:Account>
        <q9:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:Name>ResetLockoutCount</q9:Name>
          <q9:SettingNumber>30</q9:SettingNumber>
          <q9:Type>Account Lockout</q9:Type>
        </q9:Account>
        <q9:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:Name>LockoutBadCount</q9:Name>
          <q9:SettingNumber>10</q9:SettingNumber>
          <q9:Type>Account Lockout</q9:Type>
        </q9:Account>
        <q9:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:Name>PasswordHistorySize</q9:Name>
          <q9:SettingNumber>10</q9:SettingNumber>
          <q9:Type>Password</q9:Type>
        </q9:Account>
        <q9:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:Name>MinimumPasswordLength</q9:Name>
          <q9:SettingNumber>8</q9:SettingNumber>
          <q9:Type>Password</q9:Type>
        </q9:Account>
        <q9:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:Name>PasswordComplexity</q9:Name>
          <q9:SettingBoolean>true</q9:SettingBoolean>
          <q9:Type>Password</q9:Type>
        </q9:Account>
        <q9:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:Name>ClearTextPassword</q9:Name>
          <q9:SettingBoolean>false</q9:SettingBoolean>
          <q9:Type>Password</q9:Type>
        </q9:Account>
        <q9:Audit>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:Name>AuditAccountLogon</q9:Name>
          <q9:SuccessAttempts>true</q9:SuccessAttempts>
          <q9:FailureAttempts>true</q9:FailureAttempts>
        </q9:Audit>
        <q9:Audit>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:Name>AuditLogonEvents</q9:Name>
          <q9:SuccessAttempts>true</q9:SuccessAttempts>
          <q9:FailureAttempts>true</q9:FailureAttempts>
        </q9:Audit>
        <q9:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D45E698-90BC-4C88-9EF4-0840082C5D0B}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:Name>SeRemoteInteractiveLogonRight</q9:Name>
          <q9:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q9:Member>
          <q9:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain\TestUser</Name>
          </q9:Member>
        </q9:UserRightsAssignment>
        <q9:SecurityOptions>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:KeyName>MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters\AutoDisconnect</q9:KeyName>
          <q9:SettingNumber>480</q9:SettingNumber>
          <q9:Display>
            <q9:Name>Microsoft network server: Amount of idle time required before suspending session</q9:Name>
            <q9:Units>minutes</q9:Units>
            <q9:DisplayNumber>480</q9:DisplayNumber>
          </q9:Display>
        </q9:SecurityOptions>
        <q9:SecurityOptions>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:KeyName>MACHINE\System\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers\AddPrinterDrivers</q9:KeyName>
          <q9:SettingNumber>0</q9:SettingNumber>
          <q9:Display>
            <q9:Name>Devices: Prevent users from installing printer drivers</q9:Name>
            <q9:Units />
            <q9:DisplayBoolean>false</q9:DisplayBoolean>
          </q9:Display>
        </q9:SecurityOptions>
        <q9:SecurityOptions>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:KeyName>MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\InactivityTimeoutSecs</q9:KeyName>
          <q9:SettingNumber>1800</q9:SettingNumber>
          <q9:Display>
            <q9:Name>Interactive logon: Machine inactivity limit</q9:Name>
            <q9:Units>seconds</q9:Units>
            <q9:DisplayNumber>1800</q9:DisplayNumber>
          </q9:Display>
        </q9:SecurityOptions>
        <q9:SecurityOptions>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:SystemAccessPolicyName>ForceLogoffWhenHourExpire</q9:SystemAccessPolicyName>
          <q9:SettingNumber>0</q9:SettingNumber>
        </q9:SecurityOptions>
        <q9:File>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{9C94FC30-D9D9-49F5-9683-37A7AA6CCBF4}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:Path>C:\WINDOWS\MICROSOFT.NET\FRAMEWORK64\V4.0.30319\NGEN.LOG</q9:Path>
          <q9:SecurityDescriptor>
            <SDDL xmlns="http://www.microsoft.com/GroupPolicy/Types/Security">D:PAR(A;OICI;0x1200a9;;;S-1-15-2-1)(A;OICIIO;FA;;;CO)(A;OICI;FA;;;SY)(A;OICI;FA;;;BA)(A;OICI;FA;;;BU)</SDDL>
            <PermissionsPresent xmlns="http://www.microsoft.com/GroupPolicy/Types/Security">true</PermissionsPresent>
            <Permissions xmlns="http://www.microsoft.com/GroupPolicy/Types/Security">
              <InheritsFromParent>false</InheritsFromParent>
              <TrusteePermissions>
                <Trustee>
                  <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-15-2-1</SID>
                  <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES</Name>
                </Trustee>
                <Type xsi:type="PermissionType">
                  <PermissionType>Allow</PermissionType>
                </Type>
                <Inherited>false</Inherited>
                <Applicability>
                  <ToSelf>true</ToSelf>
                  <ToDescendantObjects>true</ToDescendantObjects>
                  <ToDescendantContainers>true</ToDescendantContainers>
                  <ToDirectDescendantsOnly>false</ToDirectDescendantsOnly>
                </Applicability>
                <Standard>
                  <FileGroupedAccessEnum>Read and Execute</FileGroupedAccessEnum>
                </Standard>
                <AccessMask>131241</AccessMask>
              </TrusteePermissions>
              <TrusteePermissions>
                <Trustee>
                  <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-3-0</SID>
                  <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">CREATOR OWNER</Name>
                </Trustee>
                <Type xsi:type="PermissionType">
                  <PermissionType>Allow</PermissionType>
                </Type>
                <Inherited>false</Inherited>
                <Applicability>
                  <ToSelf>false</ToSelf>
                  <ToDescendantObjects>true</ToDescendantObjects>
                  <ToDescendantContainers>true</ToDescendantContainers>
                  <ToDirectDescendantsOnly>false</ToDirectDescendantsOnly>
                </Applicability>
                <Standard>
                  <FileGroupedAccessEnum>Full Control</FileGroupedAccessEnum>
                </Standard>
                <AccessMask>983551</AccessMask>
              </TrusteePermissions>
              <TrusteePermissions>
                <Trustee>
                  <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-18</SID>
                  <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT AUTHORITY\SYSTEM</Name>
                </Trustee>
                <Type xsi:type="PermissionType">
                  <PermissionType>Allow</PermissionType>
                </Type>
                <Inherited>false</Inherited>
                <Applicability>
                  <ToSelf>true</ToSelf>
                  <ToDescendantObjects>true</ToDescendantObjects>
                  <ToDescendantContainers>true</ToDescendantContainers>
                  <ToDirectDescendantsOnly>false</ToDirectDescendantsOnly>
                </Applicability>
                <Standard>
                  <FileGroupedAccessEnum>Full Control</FileGroupedAccessEnum>
                </Standard>
                <AccessMask>983551</AccessMask>
              </TrusteePermissions>
              <TrusteePermissions>
                <Trustee>
                  <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-32-544</SID>
                  <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">BUILTIN\Administrators</Name>
                </Trustee>
                <Type xsi:type="PermissionType">
                  <PermissionType>Allow</PermissionType>
                </Type>
                <Inherited>false</Inherited>
                <Applicability>
                  <ToSelf>true</ToSelf>
                  <ToDescendantObjects>true</ToDescendantObjects>
                  <ToDescendantContainers>true</ToDescendantContainers>
                  <ToDirectDescendantsOnly>false</ToDirectDescendantsOnly>
                </Applicability>
                <Standard>
                  <FileGroupedAccessEnum>Full Control</FileGroupedAccessEnum>
                </Standard>
                <AccessMask>983551</AccessMask>
              </TrusteePermissions>
              <TrusteePermissions>
                <Trustee>
                  <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-32-545</SID>
                  <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">BUILTIN\Users</Name>
                </Trustee>
                <Type xsi:type="PermissionType">
                  <PermissionType>Allow</PermissionType>
                </Type>
                <Inherited>false</Inherited>
                <Applicability>
                  <ToSelf>true</ToSelf>
                  <ToDescendantObjects>true</ToDescendantObjects>
                  <ToDescendantContainers>true</ToDescendantContainers>
                  <ToDirectDescendantsOnly>false</ToDirectDescendantsOnly>
                </Applicability>
                <Standard>
                  <FileGroupedAccessEnum>Full Control</FileGroupedAccessEnum>
                </Standard>
                <AccessMask>983551</AccessMask>
              </TrusteePermissions>
            </Permissions>
            <AuditingPresent xmlns="http://www.microsoft.com/GroupPolicy/Types/Security">false</AuditingPresent>
          </q9:SecurityDescriptor>
          <q9:Mode>Propogate</q9:Mode>
        </q9:File>
        <q9:File>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{9C94FC30-D9D9-49F5-9683-37A7AA6CCBF4}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:Path>C:\Program Files (X86)\INTUIT\QUICKBOOKS 2014</q9:Path>
          <q9:SecurityDescriptor>
            <SDDL xmlns="http://www.microsoft.com/GroupPolicy/Types/Security">D:AR(A;OICI;0x1200a9;;;S-1-15-2-1)(A;OICIIO;FA;;;CO)(A;OICI;FA;;;SY)(A;OICI;FA;;;BA)(A;OICI;FA;;;BU)</SDDL>
            <PermissionsPresent xmlns="http://www.microsoft.com/GroupPolicy/Types/Security">true</PermissionsPresent>
            <Permissions xmlns="http://www.microsoft.com/GroupPolicy/Types/Security">
              <InheritsFromParent>true</InheritsFromParent>
              <TrusteePermissions>
                <Trustee>
                  <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-15-2-1</SID>
                  <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES</Name>
                </Trustee>
                <Type xsi:type="PermissionType">
                  <PermissionType>Allow</PermissionType>
                </Type>
                <Inherited>false</Inherited>
                <Applicability>
                  <ToSelf>true</ToSelf>
                  <ToDescendantObjects>true</ToDescendantObjects>
                  <ToDescendantContainers>true</ToDescendantContainers>
                  <ToDirectDescendantsOnly>false</ToDirectDescendantsOnly>
                </Applicability>
                <Standard>
                  <FileGroupedAccessEnum>Read and Execute</FileGroupedAccessEnum>
                </Standard>
                <AccessMask>131241</AccessMask>
              </TrusteePermissions>
              <TrusteePermissions>
                <Trustee>
                  <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-3-0</SID>
                  <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">CREATOR OWNER</Name>
                </Trustee>
                <Type xsi:type="PermissionType">
                  <PermissionType>Allow</PermissionType>
                </Type>
                <Inherited>false</Inherited>
                <Applicability>
                  <ToSelf>false</ToSelf>
                  <ToDescendantObjects>true</ToDescendantObjects>
                  <ToDescendantContainers>true</ToDescendantContainers>
                  <ToDirectDescendantsOnly>false</ToDirectDescendantsOnly>
                </Applicability>
                <Standard>
                  <FileGroupedAccessEnum>Full Control</FileGroupedAccessEnum>
                </Standard>
                <AccessMask>983551</AccessMask>
              </TrusteePermissions>
              <TrusteePermissions>
                <Trustee>
                  <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-18</SID>
                  <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT AUTHORITY\SYSTEM</Name>
                </Trustee>
                <Type xsi:type="PermissionType">
                  <PermissionType>Allow</PermissionType>
                </Type>
                <Inherited>false</Inherited>
                <Applicability>
                  <ToSelf>true</ToSelf>
                  <ToDescendantObjects>true</ToDescendantObjects>
                  <ToDescendantContainers>true</ToDescendantContainers>
                  <ToDirectDescendantsOnly>false</ToDirectDescendantsOnly>
                </Applicability>
                <Standard>
                  <FileGroupedAccessEnum>Full Control</FileGroupedAccessEnum>
                </Standard>
                <AccessMask>983551</AccessMask>
              </TrusteePermissions>
              <TrusteePermissions>
                <Trustee>
                  <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-32-544</SID>
                  <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">BUILTIN\Administrators</Name>
                </Trustee>
                <Type xsi:type="PermissionType">
                  <PermissionType>Allow</PermissionType>
                </Type>
                <Inherited>false</Inherited>
                <Applicability>
                  <ToSelf>true</ToSelf>
                  <ToDescendantObjects>true</ToDescendantObjects>
                  <ToDescendantContainers>true</ToDescendantContainers>
                  <ToDirectDescendantsOnly>false</ToDirectDescendantsOnly>
                </Applicability>
                <Standard>
                  <FileGroupedAccessEnum>Full Control</FileGroupedAccessEnum>
                </Standard>
                <AccessMask>983551</AccessMask>
              </TrusteePermissions>
              <TrusteePermissions>
                <Trustee>
                  <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-32-545</SID>
                  <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">BUILTIN\Users</Name>
                </Trustee>
                <Type xsi:type="PermissionType">
                  <PermissionType>Allow</PermissionType>
                </Type>
                <Inherited>false</Inherited>
                <Applicability>
                  <ToSelf>true</ToSelf>
                  <ToDescendantObjects>true</ToDescendantObjects>
                  <ToDescendantContainers>true</ToDescendantContainers>
                  <ToDirectDescendantsOnly>false</ToDirectDescendantsOnly>
                </Applicability>
                <Standard>
                  <FileGroupedAccessEnum>Full Control</FileGroupedAccessEnum>
                </Standard>
                <AccessMask>983551</AccessMask>
              </TrusteePermissions>
            </Permissions>
            <AuditingPresent xmlns="http://www.microsoft.com/GroupPolicy/Types/Security">false</AuditingPresent>
          </q9:SecurityDescriptor>
          <q9:Mode>Propogate</q9:Mode>
        </q9:File>
        <q9:Registry>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{9C94FC30-D9D9-49F5-9683-37A7AA6CCBF4}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q9:Path>MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\PnpLockdownFiles</q9:Path>
          <q9:SecurityDescriptor>
            <SDDL xmlns="http://www.microsoft.com/GroupPolicy/Types/Security">D:AR(A;CI;KR;;;S-1-15-2-1)(A;CIIO;KA;;;CO)(A;CI;KA;;;SY)(A;CI;KA;;;BA)(A;CI;KA;;;BU)</SDDL>
            <PermissionsPresent xmlns="http://www.microsoft.com/GroupPolicy/Types/Security">true</PermissionsPresent>
            <Permissions xmlns="http://www.microsoft.com/GroupPolicy/Types/Security">
              <InheritsFromParent>true</InheritsFromParent>
              <TrusteePermissions>
                <Trustee>
                  <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-15-2-1</SID>
                  <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES</Name>
                </Trustee>
                <Type xsi:type="PermissionType">
                  <PermissionType>Allow</PermissionType>
                </Type>
                <Inherited>false</Inherited>
                <Applicability>
                  <ToSelf>true</ToSelf>
                  <ToDescendantObjects>false</ToDescendantObjects>
                  <ToDescendantContainers>true</ToDescendantContainers>
                  <ToDirectDescendantsOnly>false</ToDirectDescendantsOnly>
                </Applicability>
                <Standard>
                  <RegistryGroupedAccessEnum>Read</RegistryGroupedAccessEnum>
                </Standard>
                <AccessMask>131097</AccessMask>
              </TrusteePermissions>
              <TrusteePermissions>
                <Trustee>
                  <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-3-0</SID>
                  <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">CREATOR OWNER</Name>
                </Trustee>
                <Type xsi:type="PermissionType">
                  <PermissionType>Allow</PermissionType>
                </Type>
                <Inherited>false</Inherited>
                <Applicability>
                  <ToSelf>false</ToSelf>
                  <ToDescendantObjects>false</ToDescendantObjects>
                  <ToDescendantContainers>true</ToDescendantContainers>
                  <ToDirectDescendantsOnly>false</ToDirectDescendantsOnly>
                </Applicability>
                <Standard>
                  <RegistryGroupedAccessEnum>Full Control</RegistryGroupedAccessEnum>
                </Standard>
                <AccessMask>983103</AccessMask>
              </TrusteePermissions>
              <TrusteePermissions>
                <Trustee>
                  <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-18</SID>
                  <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT AUTHORITY\SYSTEM</Name>
                </Trustee>
                <Type xsi:type="PermissionType">
                  <PermissionType>Allow</PermissionType>
                </Type>
                <Inherited>false</Inherited>
                <Applicability>
                  <ToSelf>true</ToSelf>
                  <ToDescendantObjects>false</ToDescendantObjects>
                  <ToDescendantContainers>true</ToDescendantContainers>
                  <ToDirectDescendantsOnly>false</ToDirectDescendantsOnly>
                </Applicability>
                <Standard>
                  <RegistryGroupedAccessEnum>Full Control</RegistryGroupedAccessEnum>
                </Standard>
                <AccessMask>983103</AccessMask>
              </TrusteePermissions>
              <TrusteePermissions>
                <Trustee>
                  <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-32-544</SID>
                  <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">BUILTIN\Administrators</Name>
                </Trustee>
                <Type xsi:type="PermissionType">
                  <PermissionType>Allow</PermissionType>
                </Type>
                <Inherited>false</Inherited>
                <Applicability>
                  <ToSelf>true</ToSelf>
                  <ToDescendantObjects>false</ToDescendantObjects>
                  <ToDescendantContainers>true</ToDescendantContainers>
                  <ToDirectDescendantsOnly>false</ToDirectDescendantsOnly>
                </Applicability>
                <Standard>
                  <RegistryGroupedAccessEnum>Full Control</RegistryGroupedAccessEnum>
                </Standard>
                <AccessMask>983103</AccessMask>
              </TrusteePermissions>
              <TrusteePermissions>
                <Trustee>
                  <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-32-545</SID>
                  <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">BUILTIN\Users</Name>
                </Trustee>
                <Type xsi:type="PermissionType">
                  <PermissionType>Allow</PermissionType>
                </Type>
                <Inherited>false</Inherited>
                <Applicability>
                  <ToSelf>true</ToSelf>
                  <ToDescendantObjects>false</ToDescendantObjects>
                  <ToDescendantContainers>true</ToDescendantContainers>
                  <ToDirectDescendantsOnly>false</ToDirectDescendantsOnly>
                </Applicability>
                <Standard>
                  <RegistryGroupedAccessEnum>Full Control</RegistryGroupedAccessEnum>
                </Standard>
                <AccessMask>983103</AccessMask>
              </TrusteePermissions>
            </Permissions>
            <AuditingPresent xmlns="http://www.microsoft.com/GroupPolicy/Types/Security">false</AuditingPresent>
          </q9:SecurityDescriptor>
          <q9:Mode>Propogate</q9:Mode>
        </q9:Registry>
      </Extension>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Settings">Security</Name>
    </ExtensionData>
    <ExtensionData>
      <Extension xmlns:q10="http://www.microsoft.com/GroupPolicy/Settings/PublicKey" xsi:type="q10:PublicKeySettings" xmlns="http://www.microsoft.com/GroupPolicy/Settings">
        <q10:AutoEnrollmentSettings>
          <q10:EnrollCertificatesAutomatically>true</q10:EnrollCertificatesAutomatically>
          <q10:Options>
            <q10:RenewUpdateRevoke>false</q10:RenewUpdateRevoke>
            <q10:UpdateTemplates>false</q10:UpdateTemplates>
          </q10:Options>
          <q10:ExpiryNotification>false</q10:ExpiryNotification>
          <q10:NotifyPercent>
            <q10:Present>false</q10:Present>
            <q10:Value>10</q10:Value>
          </q10:NotifyPercent>
        </q10:AutoEnrollmentSettings>
        <q10:EFSSettings>
          <q10:AllowEFS>2</q10:AllowEFS>
          <q10:Options>0</q10:Options>
          <q10:CacheTimeout>0</q10:CacheTimeout>
          <q10:KeyLen>0</q10:KeyLen>
        </q10:EFSSettings>
        <q10:EFSRecoveryAgent>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q10:IssuedTo>Administrator</q10:IssuedTo>
          <q10:IssuedBy>Administrator</q10:IssuedBy>
          <q10:ExpirationDate>2007-07-25T20:24:16Z</q10:ExpirationDate>
          <q10:CertificatePurpose>
            <q10:Purpose>1.3.6.1.4.1.311.10.3.4.1</q10:Purpose>
          </q10:CertificatePurpose>
          <q10:Data>0300000001000000140000000CDFBCDE8057E57E992298F6BB6FC708B965AA570200000001000000C40000001C0000006C0000000100000000000000000000000000000001000000340061003000330037003100370039002D0039006300650036002D0034006300660066002D0062003700640033002D0030006300610061003500650066003000300065003100330000000000000000004D006900630072006F0073006F0066007400200042006100730065002000430072007900700074006F0067007200610070006800690063002000500072006F00760069006400650072002000760031002E0030000000000020000000010000003B02000030820237308201A4A0030201020210C5FDBE6A30C30E8944560EFCE3B1C9B6300906052B0E03021D05003050311630140603550403130D41646D696E6973747261746F72310C300A0603550407130345465331283026060355040B131F4546532046696C6520456E6372797074696F6E204365727469666963617465301E170D3034303732353230323431365A170D3037303732353230323431365A3050311630140603550403130D41646D696E6973747261746F72310C300A0603550407130345465331283026060355040B131F4546532046696C6520456E6372797074696F6E20436572746966696361746530819F300D06092A864886F70D010101050003818D0030818902818100C4F3FCE98C660089BE60B752B232EC14FCED8D2A2E0F1642BBEFE216693062DB020034495B852D31196413E4356F058D57D93511FD7232581ADB881FC577E97289495A4BF02C987D75B68EAB2B52FC102B8D2C3FD9BEA390F036C5CF52739F7DF8B2F6478496022FCA13BC758AAF3A826B35B80F6259AE1E3A02131C4BDD77230203010001A31A301830160603551D25040F300D060B2B0601040182370A030401300906052B0E03021D050003818100096A3402CD1B72F7910CFF8991A3DB69B15D197C52ABEDB72BD0B806A31893EDC137601743BC2C9E702132220AEE899F0528144B94B229A7D86E85853810406A3C343DDDBCF9C70E4299A9D1174F142F9FDAA9F331B7D4732BE097D936470AC907A003B8EED9612A5E25F147B4D97374BDF862EFE547809D611AD62D57C4F304</q10:Data>
        </q10:EFSRecoveryAgent>
        <q10:RootCertificateSettings>
          <q10:AllowNewCAs>true</q10:AllowNewCAs>
          <q10:TrustThirdPartyCAs>true</q10:TrustThirdPartyCAs>
          <q10:RequireUPNNamingConstraints>false</q10:RequireUPNNamingConstraints>
        </q10:RootCertificateSettings>
        <q10:RootCertificate>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q10:IssuedTo>Livigent CA</q10:IssuedTo>
          <q10:IssuedBy>Livigent CA</q10:IssuedBy>
          <q10:ExpirationDate>2024-05-09T15:58:26Z</q10:ExpirationDate>
          <q10:Data>0400000001000000100000008859E6F60CD3EA41EDB43A38BFF726A10F0000000100000014000000D9143EBB508282E4BEE9C6525493B0CA663EA7BA14000000010000001400000002B04D70CFCB5EC640017CF489968034FFDECD951900000001000000100000005CFADB0047B0438F081637B3B89644E903000000010000001400000027604DD1F0FD58C361C48666F2D1B890C98EE2695C0000000100000004000000000400002000000001000000D8010000308201D43082013DA003020102020900B02BA38247617AD4300D06092A864886F70D01010505003023310B3009060355040613025553311430120603550403130B4C69766967656E74204341301E170D3134303531323135353832365A170D3234303530393135353832365A3023310B3009060355040613025553311430120603550403130B4C69766967656E7420434130819F300D06092A864886F70D010101050003818D0030818902818100BFE2E5043FE1FE69C46EB261619E08F48778F1CEE61D78E6C74874254311EA18325BD6EC67D23643315760EE4F6A2ACE6351E758C71719762F682412A679F9467C59101A76A9EC78E55DA21C33AD0DA99363ED9E0C9242B633A9B4F93466331EF91F59876B26ABC5426F401283B962B281C3FEA4C3C11688A49B8381CCCFABD50203010001A310300E300C0603551D13040530030101FF300D06092A864886F70D010105050003818100B5B48CF9EF98154ABB6F4794C98CD2FB872AD2179FF23558103FC61ADAD128072E09DF2E28464D53F30B3E92677EE6EEE25B57ECAFC46C841C6F93D47453787874599CC788B9EB04665E16146AC200E117AD35A3F902B1B32C082559E0996190AD7B04D5F2E3DCC823FE200B5A492853DB68C954BC2C11681BBA97CD4D9FEDA3</q10:Data>
        </q10:RootCertificate>
        <q10:RootCertificate>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{401E1247-8143-425E-8D36-E5B53546D0A6}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q10:IssuedTo>Livigent CA</q10:IssuedTo>
          <q10:IssuedBy>Livigent CA</q10:IssuedBy>
          <q10:ExpirationDate>2027-01-09T19:13:59Z</q10:ExpirationDate>
          <q10:Data>0400000001000000100000005F3B279909DA460D82152DF5370D3D450F0000000100000014000000D5B6882C638F22CEF00A8008F53C1C2AD9DCFFD7140000000100000014000000E86F135437D065467946175FF0BA746F1A24639419000000010000001000000003DB94175AC9415EB20F2F803DF896E1030000000100000014000000F49C1C8EEEBCDE3D0C451AD3BFB47E1797EBA8FE5C0000000100000004000000000400002000000001000000D8010000308201D43082013DA003020102020900E8949CDD814039AD300D06092A864886F70D01010505003023310B3009060355040613025553311430120603550403130B4C69766967656E74204341301E170D3137303131313139313335395A170D3237303130393139313335395A3023310B3009060355040613025553311430120603550403130B4C69766967656E7420434130819F300D06092A864886F70D010101050003818D0030818902818100E0DF95A975C8455AA8DA4107E8A69D3AFB8F2F6FAB2595FDC9979068953BC393CFFF3BE1D1089BE0C15909838EEF8CCEDD501E7A9DCA156A9BBE3625202178DF7EA997F931A123260C0C82906281AD5DA2CF69889F833B751D04C679ECC9AEBBBBA69F01EEC4603348BEED5F94058ECDB44C13C9B55979428EA11DFF0F00A91F0203010001A310300E300C0603551D13040530030101FF300D06092A864886F70D010105050003818100407227F9E1F4B98CF61CA23FE36F81A89339DF466C4B124675CB0D86C6F352D8EAE69DDE1208EA6E54A0D1C247016C162DA7BE123B87AC747864049C0DB3FF568DBE0B94D78EED7B9C0BBCBCBB97959A984935BD8E9D4FC615D133724AC37003BB7F8A2C0C13699B0B4CAE671C2F4C7DADC5ABA62A33831DD0F40B8853BD9B0B</q10:Data>
        </q10:RootCertificate>
      </Extension>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Settings">Public Key</Name>
    </ExtensionData>
    <ExtensionData>
      <Extension xmlns:q11="http://www.microsoft.com/GroupPolicy/Settings/WindowsFirewall" xsi:type="q11:WindowsFirewallSettings" xmlns="http://www.microsoft.com/GroupPolicy/Settings">
        <q11:GlobalSettings>
          <q11:PolicyVersion>
            <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
              <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
              <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
            </GPO>
            <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
            <q11:Value>534</q11:Value>
          </q11:PolicyVersion>
        </q11:GlobalSettings>
        <q11:TestDomainProfile>
          <q11:DefaultInboundAction>
            <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
              <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
              <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
            </GPO>
            <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
            <q11:Value>true</q11:Value>
          </q11:DefaultInboundAction>
          <q11:EnableFirewall>
            <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
              <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
              <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
            </GPO>
            <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
            <q11:Value>true</q11:Value>
          </q11:EnableFirewall>
        </q11:TestDomainProfile>
        <q11:PublicProfile>
          <q11:DefaultInboundAction>
            <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
              <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
              <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
            </GPO>
            <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
            <q11:Value>true</q11:Value>
          </q11:DefaultInboundAction>
          <q11:EnableFirewall>
            <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
              <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
              <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
            </GPO>
            <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
            <q11:Value>true</q11:Value>
          </q11:EnableFirewall>
        </q11:PublicProfile>
        <q11:PrivateProfile>
          <q11:DefaultInboundAction>
            <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
              <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
              <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
            </GPO>
            <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
            <q11:Value>true</q11:Value>
          </q11:DefaultInboundAction>
          <q11:EnableFirewall>
            <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
              <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
              <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
            </GPO>
            <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
            <q11:Value>true</q11:Value>
          </q11:EnableFirewall>
        </q11:PrivateProfile>
        <q11:InboundFirewallRules>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q11:Version>2.20</q11:Version>
          <q11:Action>Allow</q11:Action>
          <q11:Name>Allow HTTPS</q11:Name>
          <q11:Dir>In</q11:Dir>
          <q11:LPort>443</q11:LPort>
          <q11:Protocol>6</q11:Protocol>
          <q11:Active>true</q11:Active>
        </q11:InboundFirewallRules>
        <q11:InboundFirewallRules>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q11:Version>2.20</q11:Version>
          <q11:Action>Allow</q11:Action>
          <q11:Name>Allow DHCP Requests</q11:Name>
          <q11:Dir>In</q11:Dir>
          <q11:LPort>67</q11:LPort>
          <q11:LPort>68</q11:LPort>
          <q11:Protocol>17</q11:Protocol>
          <q11:Active>true</q11:Active>
        </q11:InboundFirewallRules>
        <q11:InboundFirewallRules>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q11:Version>2.20</q11:Version>
          <q11:Action>Allow</q11:Action>
          <q11:Name>Allow Local Subnet</q11:Name>
          <q11:Dir>In</q11:Dir>
          <q11:RA4>200.200.200.0/255.255.255.0</q11:RA4>
          <q11:RA4>192.168.168.0/255.255.255.0</q11:RA4>
          <q11:RA4>192.168.0.0/255.255.255.0</q11:RA4>
          <q11:RA4>192.168.49.0/255.255.255.0</q11:RA4>
          <q11:RA4>10.33.1.50-10.33.1.60</q11:RA4>
          <q11:Active>true</q11:Active>
        </q11:InboundFirewallRules>
        <q11:InboundFirewallRules>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q11:Version>2.20</q11:Version>
          <q11:Action>Block</q11:Action>
          <q11:Name>Block ICMP</q11:Name>
          <q11:Dir>In</q11:Dir>
          <q11:Protocol>1</q11:Protocol>
          <q11:Active>false</q11:Active>
        </q11:InboundFirewallRules>
        <q11:OutboundFirewallRules>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q11:Version>2.20</q11:Version>
          <q11:Action>Allow</q11:Action>
          <q11:Name>Allow all outbound</q11:Name>
          <q11:Dir>Out</q11:Dir>
          <q11:Active>true</q11:Active>
        </q11:OutboundFirewallRules>
      </Extension>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Settings">Windows Firewall</Name>
    </ExtensionData>
    <ExtensionData>
      <Extension xmlns:q12="http://www.microsoft.com/GroupPolicy/Settings/Registry" xsi:type="q12:RegistrySettings" xmlns="http://www.microsoft.com/GroupPolicy/Settings">
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Turn on Mapper I/O (LLTDIO) driver</q12:Name>
          <q12:State>Disabled</q12:State>
          <q12:Explain>This policy setting changes the operational behavior of the Mapper I/O network protocol driver.

LLTDIO allows a computer to discover the topology of a network it's connected to. It also allows a computer to initiate Quality-of-Service requests such as bandwidth estimation and network health analysis.

If you enable this policy setting, additional options are available to fine-tune your selection. You may choose the "Allow operation while in TestDomain" option to allow LLTDIO to operate on a network interface that's connected to a managed network. On the other hand, if a network interface is connected to an unmanaged network, you may choose the "Allow operation while in public network" and "Prohibit operation while in private network" options instead.

If you disable or do not configure this policy setting, the default behavior of LLTDIO will apply.</q12:Explain>
          <q12:Supported>At least Windows Vista</q12:Supported>
          <q12:Category>Network/Link-Layer Topology Discovery</q12:Category>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Turn on Responder (RSPNDR) driver</q12:Name>
          <q12:State>Disabled</q12:State>
          <q12:Explain>This policy setting changes the operational behavior of the Responder network protocol driver.

The Responder allows a computer to participate in Link Layer Topology Discovery requests so that it can be discovered and located on the network. It also allows a computer to participate in Quality-of-Service activities such as bandwidth estimation and network health analysis.

If you enable this policy setting, additional options are available to fine-tune your selection. You may choose the "Allow operation while in TestDomain" option to allow the Responder to operate on a network interface that's connected to a managed network. On the other hand, if a network interface is connected to an unmanaged network, you may choose the "Allow operation while in public network" and "Prohibit operation while in private network" options instead.

If you disable or do not configure this policy setting, the default behavior for the Responder will apply.</q12:Explain>
          <q12:Supported>At least Windows Vista</q12:Supported>
          <q12:Category>Network/Link-Layer Topology Discovery</q12:Category>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D45E698-90BC-4C88-9EF4-0840082C5D0B}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Windows Firewall: Allow inbound Remote Desktop exceptions</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>Allows this computer to receive inbound Remote Desktop requests. To do this, Windows Firewall opens TCP port 3389.

If you enable this policy setting, Windows Firewall opens this port so that this computer can receive Remote Desktop requests. You must specify the IP addresses or subnets from which these incoming messages are allowed. In the Windows Firewall component of Control Panel, the "Remote Desktop" check box is selected and administrators cannot clear it.

If you disable this policy setting, Windows Firewall blocks this port, which prevents this computer from receiving Remote Desktop requests. If an administrator attempts to open this port by adding it to a local port exceptions list, Windows Firewall does not open the port. In the Windows Firewall component of Control Panel, the "Remote Desktop" check box is cleared and administrators cannot select it.

If you do not configure this policy setting, Windows Firewall does not open this port. Therefore, the computer cannot receive Remote Desktop requests unless an administrator uses other policy settings to open the port. In the Windows Firewall component of Control Panel, the "Remote Desktop" check box is cleared. Administrators can change this check box."</q12:Explain>
          <q12:Supported>At least Windows XP Professional with SP2</q12:Supported>
          <q12:Category>Network/Network Connections/Windows Firewall/TestDomain Profile</q12:Category>
          <q12:EditText>
            <q12:Name>Allow unsolicited incoming messages from these IP addresses:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value />
          </q12:EditText>
          <q12:Text>
            <q12:Name>Syntax:</q12:Name>
          </q12:Text>
          <q12:Text>
            <q12:Name>Type "*" to allow messages from any network, or</q12:Name>
          </q12:Text>
          <q12:Text>
            <q12:Name>else type a comma-separated list that contains</q12:Name>
          </q12:Text>
          <q12:Text>
            <q12:Name>any number or combination of these:</q12:Name>
          </q12:Text>
          <q12:Text>
            <q12:Name>   IP addresses, such as 10.0.0.1</q12:Name>
          </q12:Text>
          <q12:Text>
            <q12:Name>   Subnet descriptions, such as 10.2.3.0/24</q12:Name>
          </q12:Text>
          <q12:Text>
            <q12:Name>   The string "localsubnet"</q12:Name>
          </q12:Text>
          <q12:Text>
            <q12:Name>Example: to allow messages from 10.0.0.1,</q12:Name>
          </q12:Text>
          <q12:Text>
            <q12:Name>10.0.0.2, and from any system on the</q12:Name>
          </q12:Text>
          <q12:Text>
            <q12:Name>local subnet or on the 10.3.4.x subnet,</q12:Name>
          </q12:Text>
          <q12:Text>
            <q12:Name>type the following in the "Allow unsolicited" </q12:Name>
          </q12:Text>
          <q12:Text>
            <q12:Name>incoming messages from these IP addresses":</q12:Name>
          </q12:Text>
          <q12:Text>
            <q12:Name>  10.0.0.1,10.0.0.2,localsubnet,10.3.4.0/24</q12:Name>
          </q12:Text>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Windows Firewall: Protect all network connections</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>Turns on Windows Firewall.

If you enable this policy setting, Windows Firewall runs and ignores the "Computer Configuration\Administrative Templates\Network\Network Connections\Prohibit use of Internet Connection Firewall on your DNS TestDomain network" policy setting.

If you disable this policy setting, Windows Firewall does not run. This is the only way to ensure that Windows Firewall does not run and administrators who log on locally cannot start it.

If you do not configure this policy setting, administrators can use the Windows Firewall component in Control Panel to turn Windows Firewall on or off, unless the "Prohibit use of Internet Connection Firewall on your DNS TestDomain network" policy setting overrides.</q12:Explain>
          <q12:Supported>At least Windows XP Professional with SP2</q12:Supported>
          <q12:Category>Network/Network Connections/Windows Firewall/TestDomain Profile</q12:Category>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Windows Firewall: Protect all network connections</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>Turns on Windows Firewall.

If you enable this policy setting, Windows Firewall runs and ignores the "Computer Configuration\Administrative Templates\Network\Network Connections\Prohibit use of Internet Connection Firewall on your DNS TestDomain network" policy setting.

If you disable this policy setting, Windows Firewall does not run. This is the only way to ensure that Windows Firewall does not run and administrators who log on locally cannot start it.

If you do not configure this policy setting, administrators can use the Windows Firewall component in Control Panel to turn Windows Firewall on or off, unless the "Prohibit use of Internet Connection Firewall on your DNS TestDomain network" policy setting overrides.</q12:Explain>
          <q12:Supported>At least Windows XP Professional with SP2</q12:Supported>
          <q12:Category>Network/Network Connections/Windows Firewall/Standard Profile</q12:Category>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Point and Print Restrictions</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>This policy setting controls the client Point and Print behavior, including the security prompts for Windows Vista computers. The policy setting applies only to non-Print Administrator clients, and only to computers that are members of a TestDomain.

          If you enable this policy setting:
          -Windows XP and later clients will only download print driver components from a list of explicitly named servers. If a compatible print driver is available on the client, a printer connection will be made. If a compatible print driver is not available on the client, no connection will be made.
          -You can configure Windows Vista clients so that security warnings and elevated command prompts do not appear when users Point and Print, or when printer connection drivers need to be updated.

          If you do not configure this policy setting:
          -Windows Vista client computers can point and print to any server.
          -Windows Vista computers will show a warning and an elevated command prompt when users create a printer connection to any server using Point and Print.
          -Windows Vista computers will show a warning and an elevated command prompt when an existing printer connection driver needs to be updated.
          -Windows Server 2003 and Windows XP client computers can create a printer connection to any server in their forest using Point and Print.

          If you disable this policy setting:
          -Windows Vista client computers can create a printer connection to any server using Point and Print.
          -Windows Vista computers will not show a warning or an elevated command prompt when users create a printer connection to any server using Point and Print.
          -Windows Vista computers will not show a warning or an elevated command prompt when an existing printer connection driver needs to be updated.
          -Windows Server 2003 and Windows XP client computers can create a printer connection to any server using Point and Print.
          -The "Users can only point and print to computers in their forest" setting applies only to Windows Server 2003 and Windows XP SP1 (and later service packs).</q12:Explain>
          <q12:Supported>At least Windows Vista</q12:Supported>
          <q12:Category>Printers</q12:Category>
          <q12:CheckBox>
            <q12:Name>Users can only point and print to these servers:</q12:Name>
            <q12:State>Disabled</q12:State>
          </q12:CheckBox>
          <q12:EditText>
            <q12:Name>Enter fully qualified server names separated by semicolons</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value />
          </q12:EditText>
          <q12:CheckBox>
            <q12:Name>Users can only point and print to machines in their forest</q12:Name>
            <q12:State>Disabled</q12:State>
          </q12:CheckBox>
          <q12:Text>
            <q12:Name />
          </q12:Text>
          <q12:Text>
            <q12:Name>Security Prompts:</q12:Name>
          </q12:Text>
          <q12:DropDownList>
            <q12:Name>When installing drivers for a new connection:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>
              <q12:Name>Do not show warning or elevation prompt</q12:Name>
            </q12:Value>
          </q12:DropDownList>
          <q12:DropDownList>
            <q12:Name>When updating drivers for an existing connection:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>
              <q12:Name>Show warning and elevation prompt</q12:Name>
            </q12:Value>
          </q12:DropDownList>
          <q12:Text>
            <q12:Name>This setting only applies to:</q12:Name>
          </q12:Text>
          <q12:Text>
            <q12:Name>Windows Vista and later</q12:Name>
          </q12:Text>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Add the Administrators security group to roaming user profiles</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>This policy setting adds the Administrator security group to the roaming user profile share.

Once an administrator has configured a user's roaming profile, the profile will be created at the user's next login. The profile is created at the location that is specified by the administrator.

For the Windows XP Professional and Windows 2000 Professional operating systems, the default file permissions for the newly generated profile are full control, or read and write access for the user, and no file access for the administrators group.

By configuring this policy setting, you can alter this behavior.

If you enable this policy setting, the administrator group is also given full control to the user's profile folder.

If you disable or do not configure this policy setting, only the user is given full control of their user profile, and the administrators group has no file system access to this folder.

Note: If the policy setting is enabled after the profile is created, the policy setting has no effect.

Note: The policy setting must be configured on the client computer, not the server, for it to have any effect, because the client computer sets the file share permissions for the roaming profile at creation time.

Note: In the default case, administrators have no file access to the user's profile, but they may still take ownership of this folder to grant themselves file permissions.

Note: The behavior when this policy setting is enabled is exactly the same behavior as in Windows NT 4.0.</q12:Explain>
          <q12:Supported>At least Windows Server 2003 operating systems or Windows XP Professional</q12:Supported>
          <q12:Category>System/User Profiles</q12:Category>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Disable detection of slow network connections</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>This policy setting disables the detection of slow network connections.

Slow link detection measures the speed of the connection between a user's computer and the remote server that stores the roaming user profile. When the system detects a slow link, the related policy settings in this folder tell the computer how to respond.

If you enable this policy setting, the system does not detect slow connections or recognize any connections as being slow. As a result, the system does not respond to slow connections to user profiles, and it ignores the policy settings that tell the system how to respond to a slow connection.

If you disable this policy setting or do not configure it, slow link detection is enabled. The system measures the speed of the connection between the user's computer and profile server. If the connection is slow (as defined by the "Slow network connection timeout for user profiles" policy setting), the system applies the other policy settings set in this folder to determine how to proceed. By default, when the connection is slow, the system loads the local copy of the user profile.</q12:Explain>
          <q12:Supported>At least Windows 2000</q12:Supported>
          <q12:Category>System/User Profiles</q12:Category>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{48C91754-D454-4371-A96D-7D699FF79E39}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Choose drive encryption method and cipher strength</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>
          This policy setting allows you to configure the algorithm and cipher strength used by BitLocker Drive Encryption. This policy setting is applied when you turn on BitLocker. Changing the encryption method has no effect if the drive is already encrypted or if encryption is in progress. Consult the BitLocker Drive Encryption Deployment Guide on Microsoft TechNet for more information about the encryption methods available. This policy is only applicable to computers running Windows 8 and later.

          If you enable this policy setting you will be able to choose an encryption algorithm and key cipher strength for BitLocker to use to encrypt drives.

          If you disable or do not configure this policy setting, BitLocker will use AES with the same bit strength (128-bit or 256-bit) as the "Choose drive encryption method and cipher strength (Windows Vista, Windows Server 2008, Windows 7)" policy setting, if it is set. If neither policy is set, BitLocker will use the default encryption method of AES 128-bit or the encryption method specified by the setup script.

      </q12:Explain>
          <q12:Supported>At least Windows Server 2012, Windows 8 or Windows RT</q12:Supported>
          <q12:Category>Windows Components/BitLocker Drive Encryption</q12:Category>
          <q12:DropDownList>
            <q12:Name>Select the encryption method:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>
              <q12:Name>AES 256-bit</q12:Name>
            </q12:Value>
          </q12:DropDownList>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">LocalGPO</Identifier>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Choose drive encryption method and cipher strength (Windows Vista, Windows Server 2008, Windows 7, Windows Server 2008 R2)</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>This policy setting allows you to configure the algorithm and cipher strength used by BitLocker Drive Encryption. This policy setting is applied when you turn on BitLocker. Changing the encryption method has no effect if the drive is already encrypted or if encryption is in progress. Consult the BitLocker Drive Encryption Deployment Guide on Microsoft TechNet for more information about the encryption methods available. This policy is only applicable to computers running Windows Server 2008, Windows Vista, Windows Server 2008 R2, or Windows 7.

If you enable this policy setting you will be able to choose an encryption algorithm and key cipher strength for BitLocker to use to encrypt drives.

If you disable or do not configure this policy setting, BitLocker will use the default encryption method of AES 128-bit with Diffuser or the encryption method specified by the setup script.

      </q12:Explain>
          <q12:Supported>Windows Server 2008, Windows 7, and Windows Vista</q12:Supported>
          <q12:Category>Windows Components/BitLocker Drive Encryption</q12:Category>
          <q12:DropDownList>
            <q12:Name>Select the encryption method:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>
              <q12:Name>AES 256-bit</q12:Name>
            </q12:Value>
          </q12:DropDownList>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">LocalGPO</Identifier>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Enforce drive encryption type on fixed data drives</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>This policy setting allows you to configure the encryption type used by BitLocker Drive Encryption. This policy setting is applied when you turn on BitLocker. Changing the encryption type has no effect if the drive is already encrypted or if encryption is in progress. Choose full encryption to require that the entire drive be encrypted when BitLocker is turned on. Choose used space only encryption to require that only the portion of the drive used to store data is encrypted when BitLocker is turned on.

If you enable this policy setting the encryption type that BitLocker will use to encrypt drives is defined by this policy and the encryption type option will not be presented in the BitLocker setup wizard.

If you disable or do not configure this policy setting, the BitLocker setup wizard will ask the user to select the encryption type before turning on BitLocker.

      </q12:Explain>
          <q12:Supported>At least Windows Server 2012 or Windows 8</q12:Supported>
          <q12:Category>Windows Components/BitLocker Drive Encryption/Fixed Data Drives</q12:Category>
          <q12:DropDownList>
            <q12:Name>Select the encryption type:</q12:Name>
            <q12:State>NotConfigured</q12:State>
          </q12:DropDownList>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{48C91754-D454-4371-A96D-7D699FF79E39}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Allow enhanced PINs for startup</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>This policy setting allows you to configure whether or not enhanced startup PINs are used with BitLocker.

Enhanced startup PINs permit the use of characters including uppercase and lowercase letters, symbols, numbers, and spaces. This policy setting is applied when you turn on BitLocker.

If you enable this policy setting, all new BitLocker startup PINs set will be enhanced PINs.

Note:   Not all computers may support enhanced PINs in the pre-boot environment. It is strongly recommended that users perform a system check during BitLocker setup.

If you disable or do not configure this policy setting, enhanced PINs will not be used.

      </q12:Explain>
          <q12:Supported>At least Windows Server 2008 R2 or Windows 7</q12:Supported>
          <q12:Category>Windows Components/BitLocker Drive Encryption/Operating System Drives</q12:Category>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{48C91754-D454-4371-A96D-7D699FF79E39}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Configure minimum PIN length for startup</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>This policy setting allows you to configure a minimum length for a Trusted Platform Module (TPM) startup PIN. This policy setting is applied when you turn on BitLocker. The startup PIN must have a minimum length of 4 digits and can have a maximum length of 20 digits.

If you enable this policy setting, you can require a minimum number of digits to be used when setting the startup PIN.

If you disable or do not configure this policy setting, users can configure a startup PIN of any length between 4 and 20 digits.

      </q12:Explain>
          <q12:Supported>At least Windows Server 2008 R2 or Windows 7</q12:Supported>
          <q12:Category>Windows Components/BitLocker Drive Encryption/Operating System Drives</q12:Category>
          <q12:Numeric>
            <q12:Name>Minimum characters:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>8</q12:Value>
          </q12:Numeric>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{48C91754-D454-4371-A96D-7D699FF79E39}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Configure use of hardware-based encryption for operating system drives</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>This policy setting allows you to manage BitLockerӳ use of hardware-based encryption on operating system drives and specify which encryption algorithms it can use with hardware-based encryption. Using hardware-based encryption can improve performance of drive operations that involve frequent reading or writing of data to the drive.

If you enable this policy setting, you can specify additional options that control whether BitLocker software-based encryption is used instead of hardware-based encryption on computers that do not support hardware-based encryption and whether you want to restrict the encryption algorithms and cipher suites used with hardware-based encryption.

If you disable this policy setting, BitLocker cannot use hardware-based encryption with operating system drives and BitLocker software-based encryption will be used by default when the drive is encrypted.

If you do not configure this policy setting, BitLocker will use hardware-based encryption with the encryption algorithm set for the drive. If hardware-based encryption is not available BitLocker software-based encryption will be used instead.

Note: The ԃhoose drive encryption method and cipher strengthԠpolicy setting does not apply to hardware-based encryption. The encryption algorithm used by hardware-based encryption is set when the drive is partitioned. By default, BitLocker uses the algorithm configured on the drive to encrypt the drive. The Ԓestrict encryption algorithms and cipher suites allowed for hardware-based encryptionԠoption enables you to restrict the encryption algorithms that BitLocker can use with hardware encryption. If the algorithm set for the drive is not available, BitLocker will disable the use of hardware-based encryption.
Encryption algorithms are specified by object identifiers (OID). For example:
- AES 128 in CBC mode OID: 2.16.840.1.101.3.4.1.2
- AES 256 in CBC mode OID: 2.16.840.1.101.3.4.1.42
      </q12:Explain>
          <q12:Supported>At least Windows Server 2012, Windows 8 or Windows RT</q12:Supported>
          <q12:Category>Windows Components/BitLocker Drive Encryption/Operating System Drives</q12:Category>
          <q12:CheckBox>
            <q12:Name>Use BitLocker software-based encryption when hardware encryption is not available</q12:Name>
            <q12:State>Enabled</q12:State>
          </q12:CheckBox>
          <q12:CheckBox>
            <q12:Name>Restrict encryption algorithms and cipher suites allowed for hardware-based encryption</q12:Name>
            <q12:State>Enabled</q12:State>
          </q12:CheckBox>
          <q12:EditText>
            <q12:Name>Restrict crypto algorithms or cipher suites to the following:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>2.16.840.1.101.3.4.1.42</q12:Value>
          </q12:EditText>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{48C91754-D454-4371-A96D-7D699FF79E39}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Configure use of passwords for operating system drives</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>This policy setting specifies the constraints for passwords used to unlock BitLocker-protected operating system drives. If non-TPM protectors are allowed on operating system drives, you can provision a password, enforce complexity requirements on the password, and configure a minimum length for the password. For the complexity requirement setting to be effective the Group Policy setting "Password must meet complexity requirements" located in Computer Configuration\Windows Settings\Security Settings\Account Policies\Password Policy\ must be also enabled.

Note: These settings are enforced when turning on BitLocker, not when unlocking a volume. BitLocker will allow unlocking a drive with any of the protectors available on the drive.

If you enable this policy setting, users can configure a password that meets the requirements you define. To enforce complexity requirements on the password, select "Require complexity".

When set to "Require complexity" a connection to a TestDomain controller is necessary when BitLocker is enabled to validate the complexity the password. When set to "Allow complexity" a connection to a TestDomain controller will be attempted to validate the complexity adheres to the rules set by the policy, but if no TestDomain controllers are found the password will still be accepted regardless of actual password complexity and the drive will be encrypted using that password as a protector. When set to "Do not allow complexity", no password complexity validation will be done.

Passwords must be at least 8 characters. To configure a greater minimum length for the password, enter the desired number of characters in the "Minimum password length" box.

If you disable or do not configure this policy setting, the default length constraint of 8 characters will apply to operating system drive passwords and no complexity checks will occur.

Note: Passwords cannot be used if FIPS-compliance is enabled. The "System cryptography: Use FIPS-compliant algorithms for encryption, hashing, and signing" policy setting in Computer Configuration\Windows Settings\Security Settings\Local Policies\Security Options specifies whether FIPS-compliance is enabled.

</q12:Explain>
          <q12:Supported>At least Windows Server 2012 or Windows 8</q12:Supported>
          <q12:Category>Windows Components/BitLocker Drive Encryption/Operating System Drives</q12:Category>
          <q12:DropDownList>
            <q12:Name>Configure password complexity for operating system  drives:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>
              <q12:Name>Require password complexity</q12:Name>
            </q12:Value>
          </q12:DropDownList>
          <q12:Numeric>
            <q12:Name>Minimum password length for operating system drive:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>8</q12:Value>
          </q12:Numeric>
          <q12:Text>
            <q12:Name>Note: You must enable the "Password must meet complexity requirements" policy setting for the password complexity setting to take effect.</q12:Name>
          </q12:Text>
          <q12:CheckBox>
            <q12:Name>Require ASCII-only passwords for removable OS drives</q12:Name>
            <q12:State>Disabled</q12:State>
          </q12:CheckBox>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{48C91754-D454-4371-A96D-7D699FF79E39}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Enforce drive encryption type on operating system drives</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>This policy setting allows you to configure the encryption type used by BitLocker Drive Encryption. This policy setting is applied when you turn on BitLocker. Changing the encryption type has no effect if the drive is already encrypted or if encryption is in progress. Choose full encryption to require that the entire drive be encrypted when BitLocker is turned on. Choose used space only encryption to require that only the portion of the drive used to store data is encrypted when BitLocker is turned on.

If you enable this policy setting the encryption type that BitLocker will use to encrypt drives is defined by this policy and the encryption type option will not be presented in the BitLocker setup wizard.

If you disable or do not configure this policy setting, the BitLocker setup wizard will ask the user to select the encryption type before turning on BitLocker.

      </q12:Explain>
          <q12:Supported>At least Windows Server 2012 or Windows 8</q12:Supported>
          <q12:Category>Windows Components/BitLocker Drive Encryption/Operating System Drives</q12:Category>
          <q12:DropDownList>
            <q12:Name>Select the encryption type:</q12:Name>
            <q12:State>NotConfigured</q12:State>
          </q12:DropDownList>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{48C91754-D454-4371-A96D-7D699FF79E39}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Require additional authentication at startup</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>This policy setting allows you to configure whether BitLocker requires additional authentication each time the computer starts and whether you are using BitLocker with or without a Trusted Platform Module (TPM). This policy setting is applied when you turn on BitLocker.

Note: Only one of the additional authentication options can be required at startup, otherwise a policy error occurs.

If you want to use BitLocker on a computer without a TPM, select the "Allow BitLocker without a compatible TPM" check box. In this mode either a password or a USB drive is required for start-up. When using a startup key, the key information used to encrypt the drive is stored on the USB drive, creating a USB key. When the USB key is inserted the access to the drive is authenticated and the drive is accessible. If the USB key is lost or unavailable or if you have forgotten the password then you will need to use one of the BitLocker recovery options to access the drive.

On a computer with a compatible TPM, four types of authentication methods can be used at startup to provide added protection for encrypted data. When the computer starts, it can use only the TPM for authentication, or it can also require insertion of a USB flash drive containing a startup key, the entry of a 4-digit to 20-digit personal identification number (PIN), or both.

If you enable this policy setting, users can configure advanced startup options in the BitLocker setup wizard.

If you disable or do not configure this policy setting, users can configure only basic options on computers with a TPM.

Note: If you want to require the use of a startup PIN and a USB flash drive, you must configure BitLocker settings using the command-line tool manage-bde instead of the BitLocker Drive Encryption setup wizard.

</q12:Explain>
          <q12:Supported>At least Windows Server 2008 R2 or Windows 7</q12:Supported>
          <q12:Category>Windows Components/BitLocker Drive Encryption/Operating System Drives</q12:Category>
          <q12:CheckBox>
            <q12:Name>Allow BitLocker without a compatible TPM (requires a password or a startup key on a USB flash drive)</q12:Name>
            <q12:State>Enabled</q12:State>
          </q12:CheckBox>
          <q12:Text>
            <q12:Name>Settings for computers with a TPM:</q12:Name>
          </q12:Text>
          <q12:DropDownList>
            <q12:Name>Configure TPM startup:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>
              <q12:Name>Allow TPM</q12:Name>
            </q12:Value>
          </q12:DropDownList>
          <q12:DropDownList>
            <q12:Name>Configure TPM startup PIN:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>
              <q12:Name>Allow startup PIN with TPM</q12:Name>
            </q12:Value>
          </q12:DropDownList>
          <q12:DropDownList>
            <q12:Name>Configure TPM startup key:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>
              <q12:Name>Allow startup key with TPM</q12:Name>
            </q12:Value>
          </q12:DropDownList>
          <q12:DropDownList>
            <q12:Name>Configure TPM startup key and PIN:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>
              <q12:Name>Allow startup key and PIN with TPM</q12:Name>
            </q12:Value>
          </q12:DropDownList>
          <q12:Text>
            <q12:Name />
          </q12:Text>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{48C91754-D454-4371-A96D-7D699FF79E39}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Require additional authentication at startup (Windows Server 2008 and Windows Vista)</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>This policy setting allows you to control whether the BitLocker Drive Encryption setup wizard will be able to set up an additional authentication method that is required each time the computer starts. This policy setting is applied when you turn on BitLocker.

Note:  This policy is only applicable to computers running Windows Server 2008 or Windows Vista.

On a computer with a compatible Trusted Platform Module (TPM), two authentication methods can be used at startup to provide added protection for encrypted data. When the computer starts, it can require users to insert a USB flash drive containing a startup key. It can also require users to enter a 4-digit to 20-digit startup personal identification number (PIN).

A USB flash drive containing a startup key is needed on computers without a compatible TPM. Without a TPM, BitLocker-encrypted data is protected solely by the key material on this USB flash drive.

If you enable this policy setting, the wizard will display the page to allow the user to configure advanced startup options for BitLocker. You can further configure setting options for computers with and without a TPM.

If you disable or do not configure this policy setting, the BitLocker setup wizard will display basic steps that allow users to turn on BitLocker on computers with a TPM. In this basic wizard, no additional startup key or startup PIN can be configured.
</q12:Explain>
          <q12:Supported>Windows Server 2008 and Windows Vista</q12:Supported>
          <q12:Category>Windows Components/BitLocker Drive Encryption/Operating System Drives</q12:Category>
          <q12:CheckBox>
            <q12:Name>Allow BitLocker without a compatible TPM (requires a password or a startup key on a USB flash drive)</q12:Name>
            <q12:State>Enabled</q12:State>
          </q12:CheckBox>
          <q12:Text>
            <q12:Name>Settings for computers with a TPM:</q12:Name>
          </q12:Text>
          <q12:DropDownList>
            <q12:Name>Configure TPM startup key:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>
              <q12:Name>Allow startup key with TPM</q12:Name>
            </q12:Value>
          </q12:DropDownList>
          <q12:DropDownList>
            <q12:Name>Configure TPM startup PIN:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>
              <q12:Name>Allow startup PIN with TPM</q12:Name>
            </q12:Value>
          </q12:DropDownList>
          <q12:Text>
            <q12:Name>Important: If you require the startup key, you must not allow the startup PIN. </q12:Name>
          </q12:Text>
          <q12:Text>
            <q12:Name>If you require the startup PIN, you must not allow the startup key. Otherwise, a policy error occurs.</q12:Name>
          </q12:Text>
          <q12:Text>
            <q12:Name>Note: Do not allow both startup PIN and startup key options to hide the advanced page on a computer with a TPM.</q12:Name>
          </q12:Text>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D45E698-90BC-4C88-9EF4-0840082C5D0B}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Allow users to connect remotely by using Remote Desktop Services</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>This policy setting allows you to configure remote access to computers by using Remote Desktop Services.

If you enable this policy setting, users who are members of the Remote Desktop Users group on the target computer can connect remotely to the target computer by using Remote Desktop Services.

If you disable this policy setting, users cannot connect remotely to the target computer by using Remote Desktop Services. The target computer will maintain any current connections, but will not accept any new incoming connections.

If you do not configure this policy setting, Remote Desktop Services uses the Remote Desktop setting on the target computer to determine whether the remote connection is allowed. This setting is found on the Remote tab in the System properties sheet. By default, remote connections are not allowed.

Note: You can limit which clients are able to connect remotely by using Remote Desktop Services by configuring the policy setting at Computer Configuration\Administrative Templates\Windows Components\Remote Desktop Services\Remote Desktop Session Host\Security\Require user authentication for remote connections by using Network Level Authentication.

You can limit the number of users who can connect simultaneously by configuring the policy setting at Computer Configuration\Administrative Templates\Windows Components\Remote Desktop Services\Remote Desktop Session Host\Connections\Limit number of connections, or by configuring the policy setting Maximum Connections by using the Remote Desktop Session Host WMI Provider.
</q12:Explain>
          <q12:Supported>At least Windows Server 2003 operating systems or Windows XP Professional</q12:Supported>
          <q12:Category>Windows Components/Remote Desktop Services/Remote Desktop Session Host/Connections</q12:Category>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D45E698-90BC-4C88-9EF4-0840082C5D0B}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Do not allow local administrators to customize permissions</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>This policy setting specifies whether to disable the administrator rights to customize security permissions for the Remote Desktop Session Host server.

You can use this setting to prevent administrators from making changes to the user groups allowed to connect remotely to the  RD Session Host server. By default, administrators are able to make such changes.

If you enable this policy setting the default security descriptors for existing groups on the RD Session Host server cannot be changed. All the security descriptors are read-only.

If you disable or do not configure this policy setting, server administrators have full read/write permissions to the user security descriptors by using the Remote Desktop Session WMI Provider.

Note: The preferred method of managing user access is by adding a user to the Remote Desktop Users group.
</q12:Explain>
          <q12:Supported>At least Windows Server 2003</q12:Supported>
          <q12:Category>Windows Components/Remote Desktop Services/Remote Desktop Session Host/Security</q12:Category>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D45E698-90BC-4C88-9EF4-0840082C5D0B}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Require user authentication for remote connections by using Network Level Authentication</q12:Name>
          <q12:State>Disabled</q12:State>
          <q12:Explain>This policy setting allows you to specify whether to require user authentication for remote connections to the RD Session Host server by using Network Level Authentication. This policy setting enhances security by requiring that user authentication occur earlier in the remote connection process.

If you enable this policy setting, only client computers that support Network Level Authentication can connect to the RD Session Host server.

To determine whether a client computer supports Network Level Authentication, start Remote Desktop Connection on the client computer, click the icon in the upper-left corner of the Remote Desktop Connection dialog box, and then click About. In the About Remote Desktop Connection dialog box, look for the phrase Network Level Authentication supported.

If you disable this policy setting, Network Level Authentication is not required for user authentication before allowing remote connections to the RD Session Host server.

If you do not configure this policy setting, the local setting on the target computer will be enforced. On Windows Server 2012 and Windows 8, Network Level Authentication is enforced by default.

Important: Disabling this policy setting provides less security because user authentication will occur later in the remote connection process.
</q12:Explain>
          <q12:Supported>At least Windows Vista</q12:Supported>
          <q12:Category>Windows Components/Remote Desktop Services/Remote Desktop Session Host/Security</q12:Category>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{9C94FC30-D9D9-49F5-9683-37A7AA6CCBF4}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Allow users to patch elevated products</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>This policy setting allows users to patch elevated products.

If you enable this policy setting, all users are permitted to install patches, even when the installation program is running with elevated system privileges. Patches are updates or upgrades that replace only those program files that have changed. Because patches can easily be vehicles for malicious programs, some installations prohibit their use.

If you disable or do not configure this policy setting, by default, only system administrators can apply patches during installations with elevated privileges, such as installations offered on the desktop or displayed in Add or Remove Programs.

This policy setting does not affect installations that run in the user's security context. By default, users can install patches to programs that run in their own security context. Also, see the "Prohibit patching" policy setting.</q12:Explain>
          <q12:Supported>At least Windows 2000</q12:Supported>
          <q12:Category>Windows Components/Windows Installer</q12:Category>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{9C94FC30-D9D9-49F5-9683-37A7AA6CCBF4}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Prohibit non-administrators from applying vendor signed updates</q12:Name>
          <q12:State>Disabled</q12:State>
          <q12:Explain>This policy setting controls the ability of non-administrators to install updates that have been digitally signed by the application vendor.

Non-administrator updates provide a mechanism for the author of an application to create digitally signed updates that can be applied by non-privileged users.

If you enable this policy setting, only administrators or users with administrative privileges can apply updates to Windows Installer based applications.

If you disable or do not configure this policy setting, users without administrative privileges can install non-administrator updates.</q12:Explain>
          <q12:Supported>Windows Installer v3.0</q12:Supported>
          <q12:Category>Windows Components/Windows Installer</q12:Category>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Configure Automatic Updates</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>Specifies whether this computer will receive security updates and other important downloads through the Windows automatic updating service.

Note: This policy does not apply to Windows RT.

This setting lets you specify whether automatic updates are enabled on this computer. If the service is enabled, you must select one of the four options in the Group Policy Setting:

        2 = Notify before downloading and installing any updates.

        When Windows finds updates that apply to this computer, users will be notified that updates are ready to be downloaded. After going to Windows Update, users can download and install any available updates.

        3 = (Default setting) Download the updates automatically and notify when they are ready to be installed

        Windows finds updates that apply to the computer and downloads them in the background (the user is not notified or interrupted during this process). When the downloads are complete, users will be notified that they are ready to install. After going to Windows Update, users can install them.

        4 = Automatically download updates and install them on the schedule specified below.

        Specify the schedule using the options in the Group Policy Setting. If no schedule is specified, the default schedule for all installations will be every day at 3:00 AM. If any updates require a restart to complete the installation, Windows will restart the computer automatically. (If a user is signed in to the computer when Windows is ready to restart, the user will be notified and given the option to delay the restart.)

        On Windows 8 and later, you can set updates to install during automatic maintenance instead of a specific schedule. Automatic maintenance will install updates when the computer is not in use, and avoid doing so when the computer is running on battery power. If automatic maintenance is unable to install updates for 2 days, Windows Update will install updates right away. Users will then be notified about an upcoming restart, and that restart will only take place if there is no potential for accidental data loss.

        Automatic maintenance can be further configured by using Group Policy settings here: Computer Configuration-&gt;Administrative Templates-&gt;Windows Components-&gt;Maintenance Scheduler

        5 = Allow local administrators to select the configuration mode that Automatic Updates should notify and install updates.

        With this option, local administrators will be allowed to use the Windows Update control panel to select a configuration option of their choice. Local administrators will not be allowed to disable the configuration for Automatic Updates.

If the status for this policy is set to Disabled, any updates that are available on Windows Update must be downloaded and installed manually. To do this, search for Windows Update using Start.

If the status is set to Not Configured, use of Automatic Updates is not specified at the Group Policy level. However, an administrator can still configure Automatic Updates through Control Panel.</q12:Explain>
          <q12:Supported>Windows XP Professional Service Pack 1 or At least Windows 2000 Service Pack 3</q12:Supported>
          <q12:Category>Windows Components/Windows Update</q12:Category>
          <q12:DropDownList>
            <q12:Name>Configure automatic updating:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>
              <q12:Name>5 - Allow local admin to choose setting</q12:Name>
            </q12:Value>
          </q12:DropDownList>
          <q12:Text>
            <q12:Name>The following settings are only required and applicable if 4 is selected.</q12:Name>
          </q12:Text>
          <q12:CheckBox>
            <q12:Name>Install during automatic maintenance</q12:Name>
            <q12:State>Enabled</q12:State>
          </q12:CheckBox>
          <q12:DropDownList>
            <q12:Name>Scheduled install day: </q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>
              <q12:Name>4 - Every Wednesday</q12:Name>
            </q12:Value>
          </q12:DropDownList>
          <q12:DropDownList>
            <q12:Name>Scheduled install time:</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>
              <q12:Name>22:00</q12:Name>
            </q12:Value>
          </q12:DropDownList>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>No auto-restart with logged on users for scheduled automatic updates installations</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>Specifies that to complete a scheduled installation, Automatic Updates will wait for the computer to be restarted by any user who is logged on, instead of causing the computer to restart automatically.

If the status is set to Enabled, Automatic Updates will not restart a computer automatically during a scheduled installation if a user is logged in to the computer. Instead, Automatic Updates will notify the user to restart the computer.

Be aware that the computer needs to be restarted for the updates to take effect.

If the status is set to Disabled or Not Configured, Automatic Updates will notify the user that the computer will automatically restart in 5 minutes to complete the installation.

Note: This policy applies only when Automatic Updates is configured to perform scheduled installations of updates. If the "Configure Automatic Updates" policy is disabled, this policy has no effect.</q12:Explain>
          <q12:Supported>Windows XP Professional Service Pack 1 or At least Windows 2000 Service Pack 3</q12:Supported>
          <q12:Category>Windows Components/Windows Update</q12:Category>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Re-prompt for restart with scheduled installations</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>
        Specifies the amount of time for Automatic Updates to wait before prompting again with a scheduled restart.

        If the status is set to Enabled, a scheduled restart will occur the specified number of minutes after the previous prompt for restart was postponed.

        If the status is set to Disabled or Not Configured, the default interval is 10 minutes.

        Note: This policy applies only when Automatic Updates is configured to perform scheduled installations of updates. If the "Configure Automatic Updates" policy is disabled, this policy has no effect. This policy has no effect on Windows RT</q12:Explain>
          <q12:Supported>Windows 7, Windows Server 2008 R2, Windows Vista, Windows Server 2003, Windows XP SP2, Windows XP SP1 , Windows 2000 SP4, Windows 2000 SP3</q12:Supported>
          <q12:Category>Windows Components/Windows Update</q12:Category>
          <q12:Text>
            <q12:Name>Wait the following period before</q12:Name>
          </q12:Text>
          <q12:Text>
            <q12:Name>prompting again with a scheduled</q12:Name>
          </q12:Text>
          <q12:Numeric>
            <q12:Name>restart (minutes): </q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>120</q12:Value>
          </q12:Numeric>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Set disk cache directory</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>Configures the directory that Google Chrome will use for storing cached files on the disk.\n\nIf you set this policy, Google Chrome will use the provided directory regardless whether the user has specified the '--disk-cache-dir' flag or not.\n\nSee http://www.chromium.org/administrators/policy-list-3/user-data-directory-variables for a list of variables that can be used.\n\nIf this policy is left not set the default cache directory will be used and the user will be able to override it with the '--disk-cache-dir' command line flag.</q12:Explain>
          <q12:Supported>Microsoft Windows XP SP2 or later</q12:Supported>
          <q12:Category>Google/Google Chrome</q12:Category>
          <q12:EditText>
            <q12:Name>Set disk cache directory</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>${local_app_data}\Google\Chrome</q12:Value>
          </q12:EditText>
        </q12:Policy>
        <q12:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:Name>Set user data directory</q12:Name>
          <q12:State>Enabled</q12:State>
          <q12:Explain>Configures the directory that Google Chrome will use for storing user data.\n\nIf you set this policy, Google Chrome will use the provided directory regardless whether the user has specified the '--user-data-dir' flag or not.\n\nSee http://www.chromium.org/administrators/policy-list-3/user-data-directory-variables for a list of variables that can be used.\n\nIf this policy is left not set the default profile path will be used and the user will be able to override it with the '--user-data-dir' command line flag.</q12:Explain>
          <q12:Supported>Microsoft Windows XP SP2 or later</q12:Supported>
          <q12:Category>Google/Google Chrome</q12:Category>
          <q12:EditText>
            <q12:Name>Set user data directory</q12:Name>
            <q12:State>Enabled</q12:State>
            <q12:Value>${roaming_app_data}\Google\Chrome\User Data\Profile</q12:Value>
          </q12:EditText>
        </q12:Policy>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D45E698-90BC-4C88-9EF4-0840082C5D0B}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>SOFTWARE\Policies\Microsoft\WindowsFirewall\TestDomainProfile\Services\RemoteDesktop</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>SOFTWARE\Policies\Microsoft\WindowsFirewall</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>Software\Policies\Microsoft\Windows\LLTD</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{401E1247-8143-425E-8D36-E5B53546D0A6}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>Software\Policies\Microsoft\SystemCertificates\FVE_NKP\CRLs</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{9C94FC30-D9D9-49F5-9683-37A7AA6CCBF4}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>Software\Policies\Microsoft\Windows\Installer</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D45E698-90BC-4C88-9EF4-0840082C5D0B}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>SOFTWARE\Policies\Microsoft\WindowsFirewall\TestDomainProfile</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>Software\Policies\Microsoft\SystemCertificates\FVE\CTLs</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{401E1247-8143-425E-8D36-E5B53546D0A6}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>Software\Policies\Microsoft\SystemCertificates\DPNGRA\Certificates</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{401E1247-8143-425E-8D36-E5B53546D0A6}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>Software\Policies\Microsoft\SystemCertificates\DPNGRA\CTLs</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{401E1247-8143-425E-8D36-E5B53546D0A6}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>Software\Policies\Microsoft\SystemCertificates\FVE_NKP\CTLs</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>SOFTWARE\Policies\Microsoft\WindowsFirewall\FirewallRules</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{401E1247-8143-425E-8D36-E5B53546D0A6}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>Software\Policies\Microsoft\SystemCertificates\DPNGRA\CRLs</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>Software\Policies\Microsoft\Windows\WindowsUpdate\AU</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{401E1247-8143-425E-8D36-E5B53546D0A6}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>Software\Policies\Microsoft\SystemCertificates\FVE_NKP\Certificates</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>Software\Policies\Microsoft\Windows\System</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>Software\Policies\Microsoft\SystemCertificates\FVE\Certificates</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>Software\Policies\Google\Chrome</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{48C91754-D454-4371-A96D-7D699FF79E39}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>SOFTWARE\Policies\Microsoft\FVE</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>Software\Policies\Microsoft\SystemCertificates\FVE\CRLs</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
        <q12:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}</Identifier>
            <TestDomain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</TestDomain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q12:KeyPath>SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile</q12:KeyPath>
          <q12:AdmSetting>false</q12:AdmSetting>
        </q12:RegistrySetting>
      </Extension>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Settings">Registry</Name>
    </ExtensionData>
    <EventsDetails>
      <SinglePassEventsDetails ActivityId="{df5c3666-3284-468e-b2b9-4d8dd7c4dcd6}" ProcessingTrigger="Periodic" ProcessingAppMode="Background" LinkSpeedInKbps="550443" SlowLinkThresholdInKbps="500" TestDomainControllerName="TestAD1.TestDomain.Local" TestDomainControllerIPAddress="200.200.200.250" PolicyProcessingMode="None" PolicyElapsedTimeInMilliseconds="1328" ErrorCount="0" WarningCount="0">
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4006&lt;/EventID&gt;&lt;Version&gt;1&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;1&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:25.696079300Z'/&gt;&lt;EventRecordID&gt;2182949&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PolicyActivityId'&gt;{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}&lt;/Data&gt;&lt;Data Name='PrincipalSamName'&gt;TestDomain\TestSQL$&lt;/Data&gt;&lt;Data Name='IsMachine'&gt;1&lt;/Data&gt;&lt;Data Name='IsTestDomainJoined'&gt;true&lt;/Data&gt;&lt;Data Name='IsBackgroundProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsAsyncProcessing'&gt;false&lt;/Data&gt;&lt;Data Name='IsServiceRestart'&gt;false&lt;/Data&gt;&lt;Data Name='ReasonForSyncProcessing'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Starting periodic policy processing for computer TestDomain\TestSQL$.
Activity id: {DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5340&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:25.696079300Z'/&gt;&lt;EventRecordID&gt;2182950&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PolicyApplicationMode'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The Group Policy processing mode is Background.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:25.696079300Z'/&gt;&lt;EventRecordID&gt;2182951&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4114&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Attempting to retrieve the account information.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:25.696079300Z'/&gt;&lt;EventRecordID&gt;2182952&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4117&lt;/Data&gt;&lt;Data Name='Parameter'&gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system call to get account information.
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:25.696079300Z'/&gt;&lt;EventRecordID&gt;2182953&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4118&lt;/Data&gt;&lt;Data Name='Parameter'&gt;CN=TestSQL,OU=Servers,DC=TestDomain,DC=local&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system call to get account information completed.
CN=TestSQL,OU=Servers,DC=TestDomain,DC=local
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:25.696079300Z'/&gt;&lt;EventRecordID&gt;2182954&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4115&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Retrieved account information.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4326&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:25.696079300Z'/&gt;&lt;EventRecordID&gt;2182955&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Group Policy is trying to discover the TestDomain Controller information.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:25.696079300Z'/&gt;&lt;EventRecordID&gt;2182956&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4096&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Retrieving TestDomain Controller details.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.008593300Z'/&gt;&lt;EventRecordID&gt;2182957&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4119&lt;/Data&gt;&lt;Data Name='Parameter'&gt;TestAD1.TestDomain.Local&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making LDAP calls to connect and bind to Active Directory.
TestAD1.TestDomain.Local</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.008593300Z'/&gt;&lt;EventRecordID&gt;2182958&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4120&lt;/Data&gt;&lt;Data Name='Parameter'&gt;TestAD1.TestDomain.Local&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The LDAP call to connect and bind to Active Directory completed.
TestAD1.TestDomain.Local
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5308&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.008593300Z'/&gt;&lt;EventRecordID&gt;2182959&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='DCName'&gt;TestAD1.TestDomain.Local&lt;/Data&gt;&lt;Data Name='DCIPAddress'&gt;200.200.200.250&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>TestDomain Controller details:
	TestDomain Controller Name : TestAD1.TestDomain.Local
	TestDomain Controller IP Address : 200.200.200.250</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5326&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.008593300Z'/&gt;&lt;EventRecordID&gt;2182960&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='DCDiscoveryTimeInMilliSeconds'&gt;312&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Group Policy successfully discovered the TestDomain Controller in 312 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5309&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.008593300Z'/&gt;&lt;EventRecordID&gt;2182961&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='MachineRole'&gt;2&lt;/Data&gt;&lt;Data Name='NetworkName'&gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Computer details:
	Computer role : 2
	Network name : </EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5310&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.008593300Z'/&gt;&lt;EventRecordID&gt;2182962&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PrincipalCNName'&gt;CN=TestSQL,OU=Servers,DC=TestDomain,DC=local&lt;/Data&gt;&lt;Data Name='PrincipalTestDomainName'&gt;TestDomain.Local&lt;/Data&gt;&lt;Data Name='DCName'&gt;\\TestAD1.TestDomain.Local&lt;/Data&gt;&lt;Data Name='DCTestDomainName'&gt;TestDomain.Local&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Account details:
	Account Name : CN=TestSQL,OU=Servers,DC=TestDomain,DC=local
	Account TestDomain Name : TestDomain.Local
	DC Name : \\TestAD1.TestDomain.Local
	DC TestDomain Name : TestDomain.Local</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5311&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.133605100Z'/&gt;&lt;EventRecordID&gt;2182963&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PolicyProcessingMode'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The loopback policy processing mode is "No loopback mode".</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4126&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.133605100Z'/&gt;&lt;EventRecordID&gt;2182964&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='IsMachine'&gt;true&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Group Policy receiving applicable GPOs from the TestDomain controller.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4257&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.133605100Z'/&gt;&lt;EventRecordID&gt;2182965&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='IsMachine'&gt;true&lt;/Data&gt;&lt;Data Name='IsBackgroundProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsAsyncProcessing'&gt;true&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Starting to download policies.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5327&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.618000700Z'/&gt;&lt;EventRecordID&gt;2182966&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='NetworkBandwidthInKbps'&gt;68805436&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Estimated network bandwidth on one of the connections: 68805436 kbps.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5314&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.618000700Z'/&gt;&lt;EventRecordID&gt;2182967&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='BandwidthInkbps'&gt;550443&lt;/Data&gt;&lt;Data Name='IsSlowLink'&gt;false&lt;/Data&gt;&lt;Data Name='ThresholdInkbps'&gt;500&lt;/Data&gt;&lt;Data Name='PolicyApplicationMode'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='LinkDescription'&gt;%%4113&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>A fast link was detected. The Estimated bandwidth is 550443 kbps. The slow link threshold is 500 kbps.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.618000700Z'/&gt;&lt;EventRecordID&gt;2182968&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{108C814F-EF5F-43F0-98E3-24D28CC31E49}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{108C814F-EF5F-43F0-98E3-24D28CC31E49}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.633619300Z'/&gt;&lt;EventRecordID&gt;2182969&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;16&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{108C814F-EF5F-43F0-98E3-24D28CC31E49}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{108C814F-EF5F-43F0-98E3-24D28CC31E49}\gpt.ini
The call completed in 16 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.633619300Z'/&gt;&lt;EventRecordID&gt;2182970&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{2D45E698-90BC-4C88-9EF4-0840082C5D0B}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{2D45E698-90BC-4C88-9EF4-0840082C5D0B}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.633619300Z'/&gt;&lt;EventRecordID&gt;2182971&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{2D45E698-90BC-4C88-9EF4-0840082C5D0B}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{2D45E698-90BC-4C88-9EF4-0840082C5D0B}\gpt.ini
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.633619300Z'/&gt;&lt;EventRecordID&gt;2182972&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.633619300Z'/&gt;&lt;EventRecordID&gt;2182973&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\gpt.ini
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.633619300Z'/&gt;&lt;EventRecordID&gt;2182974&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{8D1AA99C-242E-4FB5-B424-F8032A5FAAD8}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{8D1AA99C-242E-4FB5-B424-F8032A5FAAD8}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.649247700Z'/&gt;&lt;EventRecordID&gt;2182975&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;16&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{8D1AA99C-242E-4FB5-B424-F8032A5FAAD8}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{8D1AA99C-242E-4FB5-B424-F8032A5FAAD8}\gpt.ini
The call completed in 16 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.649247700Z'/&gt;&lt;EventRecordID&gt;2182976&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{E7CCD934-0AB0-4B37-B71C-ADAC9923E8BD}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{E7CCD934-0AB0-4B37-B71C-ADAC9923E8BD}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.649247700Z'/&gt;&lt;EventRecordID&gt;2182977&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{E7CCD934-0AB0-4B37-B71C-ADAC9923E8BD}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{E7CCD934-0AB0-4B37-B71C-ADAC9923E8BD}\gpt.ini
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.649247700Z'/&gt;&lt;EventRecordID&gt;2182978&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.649247700Z'/&gt;&lt;EventRecordID&gt;2182979&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}\gpt.ini
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.649247700Z'/&gt;&lt;EventRecordID&gt;2182980&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{0C123D08-E7BC-4060-93B2-9A7CB029FCF6}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{0C123D08-E7BC-4060-93B2-9A7CB029FCF6}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.664875100Z'/&gt;&lt;EventRecordID&gt;2182981&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;15&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{0C123D08-E7BC-4060-93B2-9A7CB029FCF6}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{0C123D08-E7BC-4060-93B2-9A7CB029FCF6}\gpt.ini
The call completed in 15 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.664875100Z'/&gt;&lt;EventRecordID&gt;2182982&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{401E1247-8143-425E-8D36-E5B53546D0A6}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{401E1247-8143-425E-8D36-E5B53546D0A6}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.664875100Z'/&gt;&lt;EventRecordID&gt;2182983&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{401E1247-8143-425E-8D36-E5B53546D0A6}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{401E1247-8143-425E-8D36-E5B53546D0A6}\gpt.ini
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.664875100Z'/&gt;&lt;EventRecordID&gt;2182984&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.664875100Z'/&gt;&lt;EventRecordID&gt;2182985&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}\gpt.ini
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.664875100Z'/&gt;&lt;EventRecordID&gt;2182986&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{9C94FC30-D9D9-49F5-9683-37A7AA6CCBF4}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{9C94FC30-D9D9-49F5-9683-37A7AA6CCBF4}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.664875100Z'/&gt;&lt;EventRecordID&gt;2182987&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{9C94FC30-D9D9-49F5-9683-37A7AA6CCBF4}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{9C94FC30-D9D9-49F5-9683-37A7AA6CCBF4}\gpt.ini
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.664875100Z'/&gt;&lt;EventRecordID&gt;2182988&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{48C91754-D454-4371-A96D-7D699FF79E39}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{48C91754-D454-4371-A96D-7D699FF79E39}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.682154700Z'/&gt;&lt;EventRecordID&gt;2182989&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;16&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{48C91754-D454-4371-A96D-7D699FF79E39}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{48C91754-D454-4371-A96D-7D699FF79E39}\gpt.ini
The call completed in 16 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5257&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.682154700Z'/&gt;&lt;EventRecordID&gt;2182990&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='IsMachine'&gt;true&lt;/Data&gt;&lt;Data Name='PolicyDownloadTimeElapsedInMilliseconds'&gt;547&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Successfully completed downloading policies.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5126&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.682154700Z'/&gt;&lt;EventRecordID&gt;2182991&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='IsMachine'&gt;true&lt;/Data&gt;&lt;Data Name='IsBackgroundProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsAsyncProcessing'&gt;false&lt;/Data&gt;&lt;Data Name='NumberOfGPOsDownloaded'&gt;12&lt;/Data&gt;&lt;Data Name='NumberOfGPOsApplicable'&gt;0&lt;/Data&gt;&lt;Data Name='GPODownloadTimeElapsedInMilliseconds'&gt;547&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Group Policy successfully got applicable GPOs from the TestDomain controller.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5312&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.682154700Z'/&gt;&lt;EventRecordID&gt;2182992&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='DescriptionString'&gt;Local Group Policy
Deploy WP
Deploy FCI K Agent
Enable Windows Firewall
Sophos Deployment
Deploy Meshimer Certificate
Set Point&amp;amp;Print Settings
QB Fix/Permissions
BitLocker
Deploy Compu K Agent
Remote Desktop
Default TestDomain Policy
&lt;/Data&gt;&lt;Data Name='GPOInfoList'&gt;&amp;lt;GPO ID="Local Group Policy"&amp;gt;&amp;lt;Name&amp;gt;Local Group Policy&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;327685&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;Local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;C:\Windows\System32\GroupPolicy\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F72-3407-48AE-BA88-E8213C6761F1}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{8D1AA99C-242E-4FB5-B424-F8032A5FAAD8}"&amp;gt;&amp;lt;Name&amp;gt;Deploy WP&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;458759&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{8D1AA99C-242E-4FB5-B424-F8032A5FAAD8}\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{42B5FAAE-6536-11D2-AE5A-0000F87571E3}{40B6664F-4972-11D1-A7CA-0000F87571E3}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{E7CCD934-0AB0-4B37-B71C-ADAC9923E8BD}"&amp;gt;&amp;lt;Name&amp;gt;Deploy FCI K Agent&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;327685&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{E7CCD934-0AB0-4B37-B71C-ADAC9923E8BD}\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{42B5FAAE-6536-11D2-AE5A-0000F87571E3}{40B6664F-4972-11D1-A7CA-0000F87571E3}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}"&amp;gt;&amp;lt;Name&amp;gt;Enable Windows Firewall&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;6553700&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{2D5FE628-D4DD-4201-B30C-0190FD89E5A5}\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{B05566AC-FE9C-4368-BE01-7A4CBB6CBA11}{D02B1F72-3407-48AE-BA88-E8213C6761F1}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{0C123D08-E7BC-4060-93B2-9A7CB029FCF6}"&amp;gt;&amp;lt;Name&amp;gt;Sophos Deployment&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;131074&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{0C123D08-E7BC-4060-93B2-9A7CB029FCF6}\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{42B5FAAE-6536-11D2-AE5A-0000F87571E3}{40B6664F-4972-11D1-A7CA-0000F87571E3}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{401E1247-8143-425E-8D36-E5B53546D0A6}"&amp;gt;&amp;lt;Name&amp;gt;Deploy Meshimer Certificate&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;131074&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{401E1247-8143-425E-8D36-E5B53546D0A6}\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{53D6AB1D-2488-11D1-A28C-00C04FB94F17}][{B1BE8D72-6EAC-11D2-A4EA-00C04F79F83A}{53D6AB1D-2488-11D1-A28C-00C04FB94F17}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}"&amp;gt;&amp;lt;Name&amp;gt;Set Point&amp;amp;Print Settings&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;65537&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{8A12CCBE-0742-4446-8EA1-82139E5EE7D4}\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F72-3407-48AE-BA88-E8213C6761F1}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{9C94FC30-D9D9-49F5-9683-37A7AA6CCBF4}"&amp;gt;&amp;lt;Name&amp;gt;QB Fix/Permissions&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;851981&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{9C94FC30-D9D9-49F5-9683-37A7AA6CCBF4}\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F72-3407-48AE-BA88-E8213C6761F1}][{42B5FAAE-6536-11D2-AE5A-0000F87571E3}{40B6664F-4972-11D1-A7CA-0000F87571E3}][{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{48C91754-D454-4371-A96D-7D699FF79E39}"&amp;gt;&amp;lt;Name&amp;gt;BitLocker&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;851981&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{48C91754-D454-4371-A96D-7D699FF79E39}\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F72-3407-48AE-BA88-E8213C6761F1}][{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{108C814F-EF5F-43F0-98E3-24D28CC31E49}"&amp;gt;&amp;lt;Name&amp;gt;Deploy Compu K Agent&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;458759&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{108C814F-EF5F-43F0-98E3-24D28CC31E49}\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{42B5FAAE-6536-11D2-AE5A-0000F87571E3}{40B6664F-4972-11D1-A7CA-0000F87571E3}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{2D45E698-90BC-4C88-9EF4-0840082C5D0B}"&amp;gt;&amp;lt;Name&amp;gt;Remote Desktop&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;458759&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{2D45E698-90BC-4C88-9EF4-0840082C5D0B}\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F72-3407-48AE-BA88-E8213C6761F1}][{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{31B2F340-016D-11D2-945F-00C04FB984F9}"&amp;gt;&amp;lt;Name&amp;gt;Default TestDomain Policy&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;7995514&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{00000000-0000-0000-0000-000000000000}{CC5746A9-9B74-4BE5-AE2E-64379C86E0E4}][{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{53D6AB1B-2488-11D1-A28C-00C04FB94F17}{53D6AB1D-2488-11D1-A28C-00C04FB94F17}{D02B1F72-3407-48AE-BA88-E8213C6761F1}][{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}][{91FBB303-0CD5-4055-BF42-E512A681B325}{CC5746A9-9B74-4BE5-AE2E-64379C86E0E4}][{B1BE8D72-6EAC-11D2-A4EA-00C04F79F83A}{53D6AB1B-2488-11D1-A28C-00C04FB94F17}{53D6AB1D-2488-11D1-A28C-00C04FB94F17}][{C631DF4C-088F-4156-B058-4375F0853CD8}{D02B1F72-3407-48AE-BA88-E8213C6761F1}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>List of applicable Group Policy objects:

Local Group Policy
Deploy WP
Deploy FCI K Agent
Enable Windows Firewall
Sophos Deployment
Deploy Meshimer Certificate
Set Point&amp;Print Settings
QB Fix/Permissions
BitLocker
Deploy Compu K Agent
Remote Desktop
Default TestDomain Policy
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5313&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.682154700Z'/&gt;&lt;EventRecordID&gt;2182993&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='DescriptionString'&gt;Test HomeDir
	Denied (Security)
&lt;/Data&gt;&lt;Data Name='GPOInfoList'&gt;&amp;lt;GPO ID="{028FC632-2F46-4C50-B725-6A15C97CD7AA}"&amp;gt;&amp;lt;Name&amp;gt;Test HomeDir&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;-65529&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=TestDomain,DC=local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{028FC632-2F46-4C50-B725-6A15C97CD7AA}\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Reason&amp;gt;DENIED-SECURITY&amp;lt;/Reason&amp;gt;&amp;lt;/GPO&amp;gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The following Group Policy objects were not applicable because they were filtered out :

Test HomeDir
	Denied (Security)
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.696133800Z'/&gt;&lt;EventRecordID&gt;2182994&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4161&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Checking for Group Policy client extensions that are not part of the system.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.696133800Z'/&gt;&lt;EventRecordID&gt;2182995&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4163&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Service configuration update to standalone is not required and will be skipped.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.696133800Z'/&gt;&lt;EventRecordID&gt;2182996&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4165&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Finished checking for non-system extensions.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4016&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;1&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:26.696133800Z'/&gt;&lt;EventRecordID&gt;2182997&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='CSEExtensionId'&gt;{91FBB303-0CD5-4055-BF42-E512A681B325}&lt;/Data&gt;&lt;Data Name='CSEExtensionName'&gt;Group Policy Services&lt;/Data&gt;&lt;Data Name='IsExtensionAsyncProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsGPOListChanged'&gt;false&lt;/Data&gt;&lt;Data Name='GPOListStatusString'&gt;%%4101&lt;/Data&gt;&lt;Data Name='DescriptionString'&gt;Default TestDomain Policy
&lt;/Data&gt;&lt;Data Name='ApplicableGPOList'&gt;&amp;lt;GPO ID="{31B2F340-016D-11D2-945F-00C04FB984F9}"&amp;gt;&amp;lt;Name&amp;gt;Default TestDomain Policy&amp;lt;/Name&amp;gt;&amp;lt;/GPO&amp;gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Starting Group Policy Services Extension Processing.

List of applicable Group Policy objects: (No changes were detected.)

Default TestDomain Policy
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5016&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;2&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:27.008634800Z'/&gt;&lt;EventRecordID&gt;2182998&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='CSEElaspedTimeInMilliSeconds'&gt;312&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='CSEExtensionName'&gt;Group Policy Services&lt;/Data&gt;&lt;Data Name='CSEExtensionId'&gt;{91FBB303-0CD5-4055-BF42-E512A681B325}&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Completed Group Policy Services Extension Processing in 312 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;8006&lt;/EventID&gt;&lt;Version&gt;1&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;2&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:27.024622100Z'/&gt;&lt;EventRecordID&gt;2182999&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PolicyElaspedTimeInSeconds'&gt;1&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='PrincipalSamName'&gt;TestDomain\TestSQL$&lt;/Data&gt;&lt;Data Name='IsMachine'&gt;1&lt;/Data&gt;&lt;Data Name='IsConnectivityFailure'&gt;false&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Completed periodic policy processing for computer TestDomain\TestSQL$ in 1 seconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5315&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-14T16:14:27.024622100Z'/&gt;&lt;EventRecordID&gt;2183000&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{DF5C3666-3284-468E-B2B9-4D8DD7C4DCD6}'/&gt;&lt;Execution ProcessID='720' ThreadID='1880'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;TestSQL.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PrincipalSamName'&gt;TestDomain\TestSQL$&lt;/Data&gt;&lt;Data Name='NextPolicyApplicationTime'&gt;102&lt;/Data&gt;&lt;Data Name='NextPolicyApplicationTimeUnit'&gt;%%4100&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Next policy processing for TestDomain\TestSQL$ will be attempted in 102 minutes.</EventDescription>
        </EventRecord>
        <ExtensionProcessingTime>
          <ExtensionName>Group Policy Services</ExtensionName>
          <ExtensionGuid>{91FBB303-0CD5-4055-BF42-E512A681B325}</ExtensionGuid>
          <ElapsedTimeInMilliseconds>312</ElapsedTimeInMilliseconds>
          <ProcessedTimeStamp>2019-01-14T11:14:27.0086348-05:00</ProcessedTimeStamp>
        </ExtensionProcessingTime>
        <ExtensionProcessingTime>
          <ExtensionName>Group Policy Infrastructure</ExtensionName>
          <ExtensionGuid>{00000000-0000-0000-0000-000000000000}</ExtensionGuid>
          <ElapsedTimeInMilliseconds>1016</ElapsedTimeInMilliseconds>
          <ProcessedTimeStamp>2019-01-14T11:14:27.0246221-05:00</ProcessedTimeStamp>
        </ExtensionProcessingTime>
      </SinglePassEventsDetails>
    </EventsDetails>
  </ComputerResults>
</Rsop>
'@ )
}


$computer_results_element = $o.'Rsop'.'ComputerResults'.'GPO'
$settings_element = $o.'Rsop'.'ComputerResults'.'ExtensionData'.'Extension'

$firewall_settings = $settings_element | where-object {$_.type -match 'WindowsFirewallSettings' }
# Also, keep in mind that "q11" isnt a static value. It might be different in different in different GPResult XML
# this is  namespace querying API
# I 


if ([String]::IsNullOrempty($firewall_settings_namespace) -or ($firewall_settings_namespace -eq $null)) {
  $firewall_settings_namespace = 'http://www.microsoft.com/GroupPolicy/Settings/WindowsFirewall'
}

$firewall_settings_namespace_prefix =  $firewall_settings.getPrefixOfNamespace('http://www.microsoft.com/GroupPolicy/Settings/WindowsFirewall')

$firewall_settings_namespace = $firewall_settings.GetNamespaceOfPrefix($firewall_settings_namespace_prefix) -join ''

if ($debug_run) {
  write-output $firewall_settings_namespace
}

$profiles = @('TestDomain', 'Public' , 'Private')

$firewall_status = @{}
$firewall_gpo = @{}
$profiles | foreach-object {
  $profile = $_
  $firewall_status[$profile] = $false
  $firewall_gpo[$profile] = @()
}

$profiles | foreach-object {
  $profile = $_
  $profile_element_name = ('{0}Profile' -f $_)
  if ($debug_run) {
    [System.Console]::Error.WriteLine( ('Firewall profile: {0}' -f $profile_element_name ))
  }

  $profile_element = $firewall_settings.GetElementsByTagName($profile_element_name, $firewall_settings_namespace)
  $enable_firewall_element =  $profile_element.'EnableFirewall'
  $firewall_status[$profile] = [Boolean]($enable_firewall_element.Value)
  if ($debug_run) {
    [System.Console]::Error.WriteLine( ('Firewall status: {0}' -f $firewall_status[$profile]) )
  }
  $gpo_element = $enable_firewall_element.'GPO'
  $gpo_element_identifier = $gpo_element.'Identifier'.'#text' -join ''
  if ($debug_run) {
    [System.Console]::Error.WriteLine( ('GPO identifier: "{0}"' -f $gpo_element_identifier))
  }

  $gpo_info = '' 
  $related_gpo = $computer_results_element | where-object  {
    $gpo_reference_identifier = $_.'path'.'identifier'.'#text' ; 
    if ($gpo_reference_identifier -match $gpo_element_identifier ) {
      return $true 
    } else { 
      return $false
    }
  }
  if ($related_gpo -ne $null){
    $gpo_info = $related_gpo.Name 
  } else {
    $gpo_info = ('None (identifier : {0})' -f $gpo_element_identifier)
  }
  $firewall_gpo[$profile] += $gpo_info
  if ($debug_run) {  
     [System.Console]::Error.WriteLine(('GPO: {0}' -f $gpo_info) )
  }
}
$profiles  | foreach-object {
$profile = $_
write-output ('{0} {1} {2}' -f $profile, $firewall_status[$profile],($firewall_gpo[$profile] -join ',' ))
}
