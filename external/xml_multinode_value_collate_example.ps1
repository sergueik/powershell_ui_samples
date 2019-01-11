# Example of processing and combining the result of several DOM node values
# useful with Microsoft Group Policy reports because:
# * these are serialized in XML
# * there are typically 'Domain', 'Public', 'Private' subkeys
# only Windows Domain really cares about
#

# $debugpreference='Continue'
param (
  [Boolean]$use_inline_data = $true,
  [switch]$debug
)
$debug_run = [bool]$PSBoundParameters['debug'].IsPresent
if ($DebugPreference -match '^Continue$') {
  $debug_run = $true
}
if ($use_iline_data -eq $false ) {
$data_path = "${env:USERPROFILE}\Downloads\GPSettings.xml"

$o = [xml]( get-content -path $data_path )
} else {

$o = [xml]( @'
<?xml version="1.0" encoding="utf-16"?>
<Rsop xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.microsoft.com/GroupPolicy/Rsop">
  <ReadTime>2019-01-11T19:17:49.7941964Z</ReadTime>
  <DataType>LoggedData</DataType>
  <UserResults>
    <Version>2228228</Version>
    <Name>TestDomain\TestUser</Name>
    <Domain>TestDomain.Local</Domain>
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
      <Path>TestDomain.Local/Configuration/Sites/Default-First-Site-Name</Path>
      <Type>Site</Type>
      <Order>2</Order>
      <BlocksInheritance>false</BlocksInheritance>
      <Blocked>false</Blocked>
      <Reason>Normal</Reason>
    </SearchedSOM>
    <SearchedSOM>
      <Path>TestDomain.Local</Path>
      <Type>Domain</Type>
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
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-513</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">MESHCLUST\Domain Users</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-1-0</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Everyone</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-32-544</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">BUILTIN\Administrators</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-32-545</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">BUILTIN\Users</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-32-554</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">BUILTIN\Pre-Windows 2000 Compatible Access</Name>
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
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-512</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">MESHCLUST\Domain Admins</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-520</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">MESHCLUST\Group Policy Creator Owners</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-518</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">MESHCLUST\Schema Admins</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-519</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">MESHCLUST\Enterprise Admins</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-18-1</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Authentication authority asserted identity</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-21-1234567891-1234567891-1234567891-572</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">MESHCLUST\Denied RODC Password Replication Group</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-16-12288</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Mandatory Label\High Mandatory Level</Name>
    </SecurityGroup>
    <SlowLink>false</SlowLink>
    <ExtensionStatus>
      <Name>Group Policy Infrastructure</Name>
      <Identifier>{00000000-0000-0000-0000-000000000000}</Identifier>
      <BeginTime>2019-01-11T19:15:35</BeginTime>
      <EndTime>2019-01-11T19:15:35</EndTime>
      <LoggingStatus>Complete</LoggingStatus>
      <Error>0</Error>
    </ExtensionStatus>
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
      <Name>{31B2F340-016D-11D2-945F-00C04FB984F9}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
        <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
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
        <LinkOrder>3</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <GPO>
      <Name>{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}</Identifier>
        <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
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
        <LinkOrder>2</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
    </GPO>
    <EventsDetails>
      <SinglePassEventsDetails ActivityId="{98183b21-e59b-4805-b1d7-c5b0137508b4}" ProcessingTrigger="Manual" ProcessingAppMode="Background" LinkSpeedInKbps="0" SlowLinkThresholdInKbps="500" DomainControllerName="DC1.TestDomain.Local" DomainControllerIPAddress="10.190.222.130" PolicyProcessingMode="None" PolicyElapsedTimeInMilliseconds="658" ErrorCount="0" WarningCount="0">
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4005&lt;/EventID&gt;&lt;Version&gt;1&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;1&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.058126600Z'/&gt;&lt;EventRecordID&gt;1521496&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PolicyActivityId'&gt;{98183B21-E59B-4805-B1D7-C5B0137508B4}&lt;/Data&gt;&lt;Data Name='PrincipalSamName'&gt;TestDomain\TestUser&lt;/Data&gt;&lt;Data Name='IsMachine'&gt;0&lt;/Data&gt;&lt;Data Name='IsDomainJoined'&gt;true&lt;/Data&gt;&lt;Data Name='IsBackgroundProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsAsyncProcessing'&gt;false&lt;/Data&gt;&lt;Data Name='IsServiceRestart'&gt;false&lt;/Data&gt;&lt;Data Name='ReasonForSyncProcessing'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Starting manual processing of policy for user TestDomain\TestUser.
Activity id: {98183B21-E59B-4805-B1D7-C5B0137508B4}</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5340&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.059044700Z'/&gt;&lt;EventRecordID&gt;1521497&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PolicyApplicationMode'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The Group Policy processing mode is Background.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.059283800Z'/&gt;&lt;EventRecordID&gt;1521498&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4114&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Attempting to retrieve the account information.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.059286300Z'/&gt;&lt;EventRecordID&gt;1521499&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4117&lt;/Data&gt;&lt;Data Name='Parameter'&gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system call to get account information.
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.061364000Z'/&gt;&lt;EventRecordID&gt;1521500&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;16&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4118&lt;/Data&gt;&lt;Data Name='Parameter'&gt;CN=Administrator,CN=Users,DC=MeshClust,DC=Local&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system call to get account information completed.
CN=Administrator,CN=Users,DC=MeshClust,DC=Local
The call completed in 16 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.061365600Z'/&gt;&lt;EventRecordID&gt;1521501&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4115&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Retrieved account information.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4326&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.062320800Z'/&gt;&lt;EventRecordID&gt;1521502&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Group Policy is trying to discover the Domain Controller information.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.062322600Z'/&gt;&lt;EventRecordID&gt;1521503&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4096&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Retrieving Domain Controller details.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.374917500Z'/&gt;&lt;EventRecordID&gt;1521504&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4119&lt;/Data&gt;&lt;Data Name='Parameter'&gt;DC1.TestDomain.Local&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making LDAP calls to connect and bind to Active Directory.
DC1.TestDomain.Local</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.377376300Z'/&gt;&lt;EventRecordID&gt;1521505&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4120&lt;/Data&gt;&lt;Data Name='Parameter'&gt;DC1.TestDomain.Local&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The LDAP call to connect and bind to Active Directory completed.
DC1.TestDomain.Local
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5308&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.377379800Z'/&gt;&lt;EventRecordID&gt;1521506&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='DCName'&gt;DC1.TestDomain.Local&lt;/Data&gt;&lt;Data Name='DCIPAddress'&gt;10.190.222.130&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Domain Controller details:
	Domain Controller Name : DC1.TestDomain.Local
	Domain Controller IP Address : 10.190.222.130</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5326&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.377380800Z'/&gt;&lt;EventRecordID&gt;1521507&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='DCDiscoveryTimeInMilliSeconds'&gt;312&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Group Policy successfully discovered the Domain Controller in 312 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5309&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.377383500Z'/&gt;&lt;EventRecordID&gt;1521508&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='MachineRole'&gt;3&lt;/Data&gt;&lt;Data Name='NetworkName'&gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Computer details:
	Computer role : 3
	Network name : </EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5310&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.377385300Z'/&gt;&lt;EventRecordID&gt;1521509&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PrincipalCNName'&gt;CN=Administrator,CN=Users,DC=MeshClust,DC=Local&lt;/Data&gt;&lt;Data Name='PrincipalDomainName'&gt;TestDomain.Local&lt;/Data&gt;&lt;Data Name='DCName'&gt;\\DC1.TestDomain.Local&lt;/Data&gt;&lt;Data Name='DCDomainName'&gt;TestDomain.Local&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Account details:
	Account Name : CN=Administrator,CN=Users,DC=MeshClust,DC=Local
	Account Domain Name : TestDomain.Local
	DC Name : \\DC1.TestDomain.Local
	DC Domain Name : TestDomain.Local</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5311&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.381492300Z'/&gt;&lt;EventRecordID&gt;1521510&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PolicyProcessingMode'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The loopback policy processing mode is "No loopback mode".</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4126&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.381494000Z'/&gt;&lt;EventRecordID&gt;1521511&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='IsMachine'&gt;false&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Group Policy receiving applicable GPOs from the domain controller.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4257&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.381525900Z'/&gt;&lt;EventRecordID&gt;1521512&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='IsMachine'&gt;false&lt;/Data&gt;&lt;Data Name='IsBackgroundProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsAsyncProcessing'&gt;true&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Starting to download policies.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5327&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.687191200Z'/&gt;&lt;EventRecordID&gt;1521513&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='NetworkBandwidthInKbps'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Estimated network bandwidth on one of the connections: 0 kbps.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5314&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.690009000Z'/&gt;&lt;EventRecordID&gt;1521514&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='BandwidthInkbps'&gt;0&lt;/Data&gt;&lt;Data Name='IsSlowLink'&gt;false&lt;/Data&gt;&lt;Data Name='ThresholdInkbps'&gt;500&lt;/Data&gt;&lt;Data Name='PolicyApplicationMode'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='LinkDescription'&gt;%%4113&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>A fast link was detected. The Estimated bandwidth is 0 kbps. The slow link threshold is 500 kbps.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5257&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.690017200Z'/&gt;&lt;EventRecordID&gt;1521515&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='IsMachine'&gt;false&lt;/Data&gt;&lt;Data Name='PolicyDownloadTimeElapsedInMilliseconds'&gt;313&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Successfully completed downloading policies.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5126&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.690414200Z'/&gt;&lt;EventRecordID&gt;1521516&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-21-1234567891-1234567891-1234567891-500'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='IsMachine'&gt;true&lt;/Data&gt;&lt;Data Name='IsBackgroundProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsAsyncProcessing'&gt;false&lt;/Data&gt;&lt;Data Name='NumberOfGPOsDownloaded'&gt;0&lt;/Data&gt;&lt;Data Name='NumberOfGPOsApplicable'&gt;0&lt;/Data&gt;&lt;Data Name='GPODownloadTimeElapsedInMilliseconds'&gt;313&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Group Policy successfully got applicable GPOs from the domain controller.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5312&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.690707100Z'/&gt;&lt;EventRecordID&gt;1521517&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='DescriptionString'&gt;None&lt;/Data&gt;&lt;Data Name='GPOInfoList'&gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>List of applicable Group Policy objects:

None</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5313&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.690723400Z'/&gt;&lt;EventRecordID&gt;1521518&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='DescriptionString'&gt;Local Group Policy
	Not Applied (Empty)
&lt;/Data&gt;&lt;Data Name='GPOInfoList'&gt;&amp;lt;GPO ID="Local Group Policy"&amp;gt;&amp;lt;Name&amp;gt;Local Group Policy&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;0&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;Local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;C:\Windows\System32\GroupPolicy\User&amp;lt;/FSPath&amp;gt;&amp;lt;Reason&amp;gt;NOTAPPLIED-EMPTY&amp;lt;/Reason&amp;gt;&amp;lt;/GPO&amp;gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The following Group Policy objects were not applicable because they were filtered out :

Local Group Policy
	Not Applied (Empty)
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.703973300Z'/&gt;&lt;EventRecordID&gt;1521519&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4161&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Checking for Group Policy client extensions that are not part of the system.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.704114000Z'/&gt;&lt;EventRecordID&gt;1521520&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4163&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Service configuration update to standalone is not required and will be skipped.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.704114700Z'/&gt;&lt;EventRecordID&gt;1521521&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4165&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Finished checking for non-system extensions.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;8005&lt;/EventID&gt;&lt;Version&gt;1&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;2&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.716300400Z'/&gt;&lt;EventRecordID&gt;1521522&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PolicyElaspedTimeInSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='PrincipalSamName'&gt;TestDomain\TestUser&lt;/Data&gt;&lt;Data Name='IsMachine'&gt;0&lt;/Data&gt;&lt;Data Name='IsConnectivityFailure'&gt;false&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Completed manual processing of policy for user TestDomain\TestUser in 0 seconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5315&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.716382000Z'/&gt;&lt;EventRecordID&gt;1521523&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{98183B21-E59B-4805-B1D7-C5B0137508B4}'/&gt;&lt;Execution ProcessID='108' ThreadID='5284'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PrincipalSamName'&gt;TestDomain\TestUser&lt;/Data&gt;&lt;Data Name='NextPolicyApplicationTime'&gt;113&lt;/Data&gt;&lt;Data Name='NextPolicyApplicationTimeUnit'&gt;%%4100&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Next policy processing for TestDomain\TestUser will be attempted in 113 minutes.</EventDescription>
        </EventRecord>
        <ExtensionProcessingTime>
          <ExtensionName>Group Policy Infrastructure</ExtensionName>
          <ExtensionGuid>{00000000-0000-0000-0000-000000000000}</ExtensionGuid>
          <ElapsedTimeInMilliseconds>658</ElapsedTimeInMilliseconds>
          <ProcessedTimeStamp>2019-01-11T11:15:35.7163004-08:00</ProcessedTimeStamp>
        </ExtensionProcessingTime>
      </SinglePassEventsDetails>
    </EventsDetails>
  </UserResults>
  <ComputerResults>
    <Version>2228228</Version>
    <Name>MESHCLUST\DC1$</Name>
    <Domain>TestDomain.Local</Domain>
    <SOM>TestDomain.Local/Domain Controllers</SOM>
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
      <Path>TestDomain.Local/Configuration/Sites/Default-First-Site-Name</Path>
      <Type>Site</Type>
      <Order>2</Order>
      <BlocksInheritance>false</BlocksInheritance>
      <Blocked>false</Blocked>
      <Reason>Normal</Reason>
    </SearchedSOM>
    <SearchedSOM>
      <Path>TestDomain.Local/Domain Controllers</Path>
      <Type>OU</Type>
      <Order>4</Order>
      <BlocksInheritance>false</BlocksInheritance>
      <Blocked>false</Blocked>
      <Reason>Normal</Reason>
    </SearchedSOM>
    <SearchedSOM>
      <Path>TestDomain.Local</Path>
      <Type>Domain</Type>
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
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-16-16384</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Mandatory Label\System Mandatory Level</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-1-0</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Everyone</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-32-545</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">BUILTIN\Users</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-6</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT AUTHORITY\SERVICE</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-2-1</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">CONSOLE LOGON</Name>
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
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-864916184-135290571-3087830041-1716922880-4237303741</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\BITS</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-3256172449-2363790065-3617575471-4144056108-756904704</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\CertPropSvc</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-1436340521-1614496842-1630426791-3450112370-1043762698</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\DcpSvc</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-3841379657-834162867-3056945855-2577476187-70241904</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\dmwappushservice</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-286057374-2594772386-1471686342-3682429118-820474675</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\DsmSvc</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-3578261754-285310837-913589462-2834155770-667502746</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\Eaphost</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-698886940-375981264-2691324669-2937073286-3841916615</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\IKEEXT</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-62724632-2456781206-3863850748-1496050881-1042387526</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\iphlpsvc</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-3704025948-1094794811-1175534343-2088422159-783153058</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\lfsvc</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-917953661-2020045820-2727011118-2260243830-4032185929</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\MSiSCSI</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-154974075-1852685594-3179713959-2755908004-3936262621</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\NcaSvc</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-3290392786-819420393-1694314755-3737624005-3552167228</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\NetSetupSvc</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-1802467488-1541022566-2033325545-854566965-652742428</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\RasAuto</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-4176366874-305252471-2256717057-2714189771-3552532790</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\RasMan</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-1954729425-4294152082-187165618-318331177-3831297489</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\RemoteAccess</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-4125092361-1567024937-842823819-2091237918-836075745</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\Schedule</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-1691538513-4084330536-1620899472-1113280783-3554754292</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\SCPolicySvc</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-4259241309-1822918763-1176128033-1339750638-3428293995</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\SENS</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-4022436659-1090538466-1613889075-870485073-3428993833</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\SessionEnv</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-2009329905-444645132-2728249442-922493431-93864177</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\SharedAccess</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-1690854464-3758363787-3981977099-3843555589-1401248062</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\ShellHWDetection</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-223807737-1693445485-119162242-1977420160-1403034029</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\UsoSvc</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-3594706986-2537596223-181334840-1741483385-1351671666</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\wercplsupport</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-3750560858-172214265-3889451188-1914796615-4100997547</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\Winmgmt</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-2429767553-128593128-2427591838-1778256749-2155598187</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\wisvc</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-2952724807-2252311773-3412998076-2712868122-780978283</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\wlidsvc</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-1938892561-4120931771-3580170924-3403102300-2651602529</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\WpnService</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-80-1014140700-3308905587-3330345912-272242898-93311788</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\wuauserv</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-2-0</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">LOCAL</Name>
    </SecurityGroup>
    <SecurityGroup>
      <SID xmlns="http://www.microsoft.com/GroupPolicy/Types">S-1-5-32-544</SID>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">BUILTIN\Administrators</Name>
    </SecurityGroup>
    <SlowLink>false</SlowLink>
    <ExtensionStatus>
      <Name>Group Policy Infrastructure</Name>
      <Identifier>{00000000-0000-0000-0000-000000000000}</Identifier>
      <BeginTime>2019-01-11T19:15:33</BeginTime>
      <EndTime>2019-01-11T19:15:35</EndTime>
      <LoggingStatus>Complete</LoggingStatus>
      <Error>0</Error>
    </ExtensionStatus>
    <ExtensionStatus>
      <Name>Registry</Name>
      <Identifier>{35378EAC-683F-11D2-A89A-00C04FBBCFA2}</Identifier>
      <BeginTime>2019-01-11T19:15:34</BeginTime>
      <EndTime>2019-01-11T19:15:34</EndTime>
      <LoggingStatus>Complete</LoggingStatus>
      <Error>0</Error>
    </ExtensionStatus>
    <ExtensionStatus>
      <Name>Security</Name>
      <Identifier>{827D319E-6EAC-11D2-A4EA-00C04F79F83A}</Identifier>
      <BeginTime>2019-01-11T19:15:34</BeginTime>
      <EndTime>2019-01-11T19:15:35</EndTime>
      <LoggingStatus>Complete</LoggingStatus>
      <Error>0</Error>
    </ExtensionStatus>
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
      <Name>Default Domain Controllers Policy</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
        <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
      </Path>
      <VersionDirectory>1</VersionDirectory>
      <VersionSysvol>1</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local/Domain Controllers</SOMPath>
        <SOMOrder>1</SOMOrder>
        <AppliedOrder>3</AppliedOrder>
        <LinkOrder>4</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>Security</ExtensionName>
    </GPO>
    <GPO>
      <Name>Default Domain Policy</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
        <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
      </Path>
      <VersionDirectory>3</VersionDirectory>
      <VersionSysvol>3</VersionSysvol>
      <Enabled>true</Enabled>
      <FilterId>MSFT_SomFilter.ID="{8334DED8-4B5B-4637-B6D6-3AC2C2C18EB2}",Domain="TestDomain.Local"</FilterId>
      <FilterName>New WMI Filter</FilterName>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>2</SOMOrder>
        <AppliedOrder>2</AppliedOrder>
        <LinkOrder>3</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>{B1BE8D72-6EAC-11D2-A4EA-00C04F79F83A}</ExtensionName>
      <ExtensionName>Security</ExtensionName>
      <ExtensionName>Registry</ExtensionName>
    </GPO>
    <GPO>
      <Name>Firewall Config</Name>
      <Path>
        <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}</Identifier>
        <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
      </Path>
      <VersionDirectory>12</VersionDirectory>
      <VersionSysvol>12</VersionSysvol>
      <Enabled>true</Enabled>
      <IsValid>true</IsValid>
      <FilterAllowed>true</FilterAllowed>
      <AccessDenied>false</AccessDenied>
      <Link>
        <SOMPath>TestDomain.Local</SOMPath>
        <SOMOrder>1</SOMOrder>
        <AppliedOrder>1</AppliedOrder>
        <LinkOrder>2</LinkOrder>
        <Enabled>true</Enabled>
        <NoOverride>false</NoOverride>
      </Link>
      <SecurityFilter>NT AUTHORITY\Authenticated Users</SecurityFilter>
      <ExtensionName>Registry</ExtensionName>
    </GPO>
    <ExtensionData>
      <Extension xmlns:q1="http://www.microsoft.com/GroupPolicy/Settings/Security" xsi:type="q1:SecuritySettings" xmlns="http://www.microsoft.com/GroupPolicy/Settings">
        <q1:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>MaxRenewAge</q1:Name>
          <q1:SettingNumber>7</q1:SettingNumber>
          <q1:Type>Kerberos</q1:Type>
        </q1:Account>
        <q1:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>MaximumPasswordAge</q1:Name>
          <q1:SettingNumber>42</q1:SettingNumber>
          <q1:Type>Password</q1:Type>
        </q1:Account>
        <q1:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>MinimumPasswordAge</q1:Name>
          <q1:SettingNumber>1</q1:SettingNumber>
          <q1:Type>Password</q1:Type>
        </q1:Account>
        <q1:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>MaxServiceAge</q1:Name>
          <q1:SettingNumber>600</q1:SettingNumber>
          <q1:Type>Kerberos</q1:Type>
        </q1:Account>
        <q1:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>LockoutBadCount</q1:Name>
          <q1:SettingNumber>0</q1:SettingNumber>
          <q1:Type>Account Lockout</q1:Type>
        </q1:Account>
        <q1:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>MaxClockSkew</q1:Name>
          <q1:SettingNumber>5</q1:SettingNumber>
          <q1:Type>Kerberos</q1:Type>
        </q1:Account>
        <q1:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>MaxTicketAge</q1:Name>
          <q1:SettingNumber>10</q1:SettingNumber>
          <q1:Type>Kerberos</q1:Type>
        </q1:Account>
        <q1:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>PasswordHistorySize</q1:Name>
          <q1:SettingNumber>24</q1:SettingNumber>
          <q1:Type>Password</q1:Type>
        </q1:Account>
        <q1:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>MinimumPasswordLength</q1:Name>
          <q1:SettingNumber>7</q1:SettingNumber>
          <q1:Type>Password</q1:Type>
        </q1:Account>
        <q1:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>PasswordComplexity</q1:Name>
          <q1:SettingBoolean>true</q1:SettingBoolean>
          <q1:Type>Password</q1:Type>
        </q1:Account>
        <q1:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>ClearTextPassword</q1:Name>
          <q1:SettingBoolean>false</q1:SettingBoolean>
          <q1:Type>Password</q1:Type>
        </q1:Account>
        <q1:Account>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>TicketValidateClient</q1:Name>
          <q1:SettingBoolean>true</q1:SettingBoolean>
          <q1:Type>Kerberos</q1:Type>
        </q1:Account>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeMachineAccountPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Authenticated Users</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeChangeNotifyPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Everyone</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">LOCAL SERVICE</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NETWORK SERVICE</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Authenticated Users</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Pre-Windows 2000 Compatible Access</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeIncreaseBasePriorityPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeTakeOwnershipPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeRestorePrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Backup Operators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Server Operators</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeDebugPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeSystemTimePrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">LOCAL SERVICE</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Server Operators</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeSecurityPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeShutdownPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Backup Operators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Server Operators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Print Operators</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeAuditPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">LOCAL SERVICE</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NETWORK SERVICE</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeInteractiveLogonRight</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Backup Operators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Account Operators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Server Operators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Print Operators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">ENTERPRISE DOMAIN CONTROLLERS</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeCreatePagefilePrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeBatchLogonRight</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Backup Operators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Performance Log Users</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeNetworkLogonRight</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Everyone</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Authenticated Users</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">ENTERPRISE DOMAIN CONTROLLERS</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Pre-Windows 2000 Compatible Access</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeSystemProfilePrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NT SERVICE\WdiServiceHost</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeRemoteShutdownPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Server Operators</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeBackupPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Backup Operators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Server Operators</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeEnableDelegationPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeUndockPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeSystemEnvironmentPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeLoadDriverPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Print Operators</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeIncreaseQuotaPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">LOCAL SERVICE</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NETWORK SERVICE</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeProfileSingleProcessPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">Administrators</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:UserRightsAssignment>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:Name>SeAssignPrimaryTokenPrivilege</q1:Name>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">LOCAL SERVICE</Name>
          </q1:Member>
          <q1:Member>
            <Name xmlns="http://www.microsoft.com/GroupPolicy/Types">NETWORK SERVICE</Name>
          </q1:Member>
        </q1:UserRightsAssignment>
        <q1:SecurityOptions>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:KeyName>MACHINE\System\CurrentControlSet\Services\NTDS\Parameters\LDAPServerIntegrity</q1:KeyName>
          <q1:SettingNumber>1</q1:SettingNumber>
          <q1:Display>
            <q1:Name>Domain controller: LDAP server signing requirements</q1:Name>
            <q1:Units />
            <q1:DisplayString>None</q1:DisplayString>
          </q1:Display>
        </q1:SecurityOptions>
        <q1:SecurityOptions>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:KeyName>MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters\RequireSecuritySignature</q1:KeyName>
          <q1:SettingNumber>1</q1:SettingNumber>
          <q1:Display>
            <q1:Name>Microsoft network server: Digitally sign communications (always)</q1:Name>
            <q1:Units />
            <q1:DisplayBoolean>true</q1:DisplayBoolean>
          </q1:Display>
        </q1:SecurityOptions>
        <q1:SecurityOptions>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:KeyName>MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters\EnableSecuritySignature</q1:KeyName>
          <q1:SettingNumber>1</q1:SettingNumber>
          <q1:Display>
            <q1:Name>Microsoft network server: Digitally sign communications (if client agrees)</q1:Name>
            <q1:Units />
            <q1:DisplayBoolean>true</q1:DisplayBoolean>
          </q1:Display>
        </q1:SecurityOptions>
        <q1:SecurityOptions>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:KeyName>MACHINE\System\CurrentControlSet\Control\Lsa\NoLMHash</q1:KeyName>
          <q1:SettingNumber>1</q1:SettingNumber>
          <q1:Display>
            <q1:Name>Network security: Do not store LAN Manager hash value on next password change</q1:Name>
            <q1:Units />
            <q1:DisplayBoolean>true</q1:DisplayBoolean>
          </q1:Display>
        </q1:SecurityOptions>
        <q1:SecurityOptions>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{6AC1786C-016F-11D2-945F-00C04fB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:KeyName>MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters\RequireSignOrSeal</q1:KeyName>
          <q1:SettingNumber>1</q1:SettingNumber>
          <q1:Display>
            <q1:Name>Domain member: Digitally encrypt or sign secure channel data (always)</q1:Name>
            <q1:Units />
            <q1:DisplayBoolean>true</q1:DisplayBoolean>
          </q1:Display>
        </q1:SecurityOptions>
        <q1:SecurityOptions>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:SystemAccessPolicyName>ForceLogoffWhenHourExpire</q1:SystemAccessPolicyName>
          <q1:SettingNumber>0</q1:SettingNumber>
        </q1:SecurityOptions>
        <q1:SecurityOptions>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q1:SystemAccessPolicyName>LSAAnonymousNameLookup</q1:SystemAccessPolicyName>
          <q1:SettingNumber>0</q1:SettingNumber>
        </q1:SecurityOptions>
      </Extension>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Settings">Security</Name>
    </ExtensionData>
    <ExtensionData>
      <Extension xmlns:q2="http://www.microsoft.com/GroupPolicy/Settings/PublicKey" xsi:type="q2:PublicKeySettings" xmlns="http://www.microsoft.com/GroupPolicy/Settings">
        <q2:AutoEnrollmentSettings>
          <q2:EnrollCertificatesAutomatically>true</q2:EnrollCertificatesAutomatically>
          <q2:Options>
            <q2:RenewUpdateRevoke>false</q2:RenewUpdateRevoke>
            <q2:UpdateTemplates>false</q2:UpdateTemplates>
          </q2:Options>
          <q2:ExpiryNotification>false</q2:ExpiryNotification>
          <q2:NotifyPercent>
            <q2:Present>false</q2:Present>
            <q2:Value>10</q2:Value>
          </q2:NotifyPercent>
        </q2:AutoEnrollmentSettings>
        <q2:EFSSettings>
          <q2:AllowEFS>2</q2:AllowEFS>
          <q2:Options>0</q2:Options>
          <q2:CacheTimeout>0</q2:CacheTimeout>
          <q2:KeyLen>0</q2:KeyLen>
        </q2:EFSSettings>
        <q2:EFSRecoveryAgent>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{31B2F340-016D-11D2-945F-00C04FB984F9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q2:IssuedTo>Administrator</q2:IssuedTo>
          <q2:IssuedBy>Administrator</q2:IssuedBy>
          <q2:ExpirationDate>2118-07-13T18:26:35Z</q2:ExpirationDate>
          <q2:CertificatePurpose>
            <q2:Purpose>1.3.6.1.4.1.311.10.3.4.1</q2:Purpose>
          </q2:CertificatePurpose>
          <q2:Data>0200000001000000CC0000001C0000006C0000000100000000000000000000000000000001000000310038006100360036006500640030002D0061003000300036002D0034003800650038002D0038003300640039002D0034003800640035006400640065003100350065003800300000000000000000004D006900630072006F0073006F0066007400200045006E00680061006E006300650064002000430072007900700074006F0067007200610070006800690063002000500072006F00760069006400650072002000760031002E0030000000000003000000010000001400000001040BF38382E779B046A558AA072438A232804420000000010000008A030000308203863082026EA003020102021031C6BBA7C2D6C08344E7A81ACC7A1DBC300D06092A864886F70D01010505003050311630140603550403130D41646D696E6973747261746F72310C300A0603550407130345465331283026060355040B131F4546532046696C6520456E6372797074696F6E2043657274696669636174653020170D3138303830363138323633355A180F32313138303731333138323633355A3050311630140603550403130D41646D696E6973747261746F72310C300A0603550407130345465331283026060355040B131F4546532046696C6520456E6372797074696F6E20436572746966696361746530820122300D06092A864886F70D01010105000382010F003082010A0282010100C7A9B4713288ACFFEF978C7323DAE136FA9F5CDF9B0F274838B203F38784E0B33ED1680547310AC17508AC42F1A46777B48E333ABD2B14806DD26C424190A9CD0D803471FE78B13DE84233DCA54E3059523B99828F6938797C8BF34467F8793896FAA9C3CAB35379637DFE81B1603B8BC7B689BD66B512FD943ECBAD7D676EBA8F9A6316AE48DF3E6E57023E036F75FE4A3A77FC2ED3B88CAA8D657DF9E7D01952E00D1EEE9D1E97B781402B4220EF09D14328CB89752DB9733833046EBD6381AD7C3C205D10D19D076FD4328A90E868837E8FAD162DF590B48844FA810654A03F8811F9638227C4C55EBC88002263B713DB50BBF13FCEDD4D7AB5A36A87BFA50203010001A35A305830160603551D25040F300D060B2B0601040182370A03040130330603551D11042C302AA028060A2B060104018237140203A01A0C1841646D696E6973747261746F72404D455348434C5553540030090603551D1304023000300D06092A864886F70D010105050003820101002D920C31A1FFADF839EC8AA0C81D8F6395C8F6D1C5DAC2C6135AEC38779AC0C1BCEF25D7C8077DB818164A8E43F44709BA96EED54B7D69A44179F171A058A1E51418C17EA4EF14CEE1F0D473BF7BDDB8B73A8D5452C47AA0B8F0986F8915068894F708E455096EF720C3EE6BFD9D9DD6D99E20FA5D2E08B64F87F26D18D6093D7E26FF18174BC8A2AE423F0CB3FE41F8A02BE7854A4A90DA9FBD5AA3A9B6AB18E70BAF466F15060604A124968A8BAA312191D5800C043F9AA1DEAE1680D837E8C70F1EC4800DC659D3D08235EA0F3198AA60BABC070E729B2B07710F521D0D19E59C395DBBCB815BF89757B15C1EA0EB2A07ABDF9FE8357F0A3FA3B773FCF994</q2:Data>
        </q2:EFSRecoveryAgent>
        <q2:RootCertificateSettings>
          <q2:AllowNewCAs>true</q2:AllowNewCAs>
          <q2:TrustThirdPartyCAs>true</q2:TrustThirdPartyCAs>
          <q2:RequireUPNNamingConstraints>false</q2:RequireUPNNamingConstraints>
        </q2:RootCertificateSettings>
      </Extension>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Settings">Public Key</Name>
    </ExtensionData>
    <ExtensionData>
      <Extension xmlns:q3="http://www.microsoft.com/GroupPolicy/Settings/WindowsFirewall" xsi:type="q3:WindowsFirewallSettings" xmlns="http://www.microsoft.com/GroupPolicy/Settings">
        <q3:GlobalSettings>
          <q3:PolicyVersion>
            <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
              <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}</Identifier>
              <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
            </GPO>
            <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
            <q3:Value>538</q3:Value>
          </q3:PolicyVersion>
        </q3:GlobalSettings>
        <q3:DomainProfile>
          <q3:EnableFirewall>
            <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
              <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}</Identifier>
              <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
            </GPO>
            <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
            <q3:Value>true</q3:Value>
          </q3:EnableFirewall>
        </q3:DomainProfile>
        <q3:PublicProfile>
          <q3:EnableFirewall>
            <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
              <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}</Identifier>
              <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
            </GPO>
            <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
            <q3:Value>true</q3:Value>
          </q3:EnableFirewall>
        </q3:PublicProfile>
        <q3:PrivateProfile>
          <q3:EnableFirewall>
            <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
              <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}</Identifier>
              <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
            </GPO>
            <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
            <q3:Value>true</q3:Value>
          </q3:EnableFirewall>
        </q3:PrivateProfile>
      </Extension>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Settings">Windows Firewall</Name>
    </ExtensionData>
    <ExtensionData>
      <Extension xmlns:q4="http://www.microsoft.com/GroupPolicy/Settings/Registry" xsi:type="q4:RegistrySettings" xmlns="http://www.microsoft.com/GroupPolicy/Settings">
        <q4:Policy>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q4:Name>Windows Firewall: Protect all network connections</q4:Name>
          <q4:State>Enabled</q4:State>
          <q4:Explain>Turns on Windows Firewall.

If you enable this policy setting, Windows Firewall runs and ignores the "Computer Configuration\Administrative Templates\Network\Network Connections\Prohibit use of Internet Connection Firewall on your DNS domain network" policy setting.

If you disable this policy setting, Windows Firewall does not run. This is the only way to ensure that Windows Firewall does not run and administrators who log on locally cannot start it.

If you do not configure this policy setting, administrators can use the Windows Firewall component in Control Panel to turn Windows Firewall on or off, unless the "Prohibit use of Internet Connection Firewall on your DNS domain network" policy setting overrides.</q4:Explain>
          <q4:Supported>At least Windows XP Professional with SP2</q4:Supported>
          <q4:Category>Network/Network Connections/Windows Firewall/Domain Profile</q4:Category>
        </q4:Policy>
        <q4:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q4:KeyPath>SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile</q4:KeyPath>
          <q4:AdmSetting>false</q4:AdmSetting>
        </q4:RegistrySetting>
        <q4:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q4:KeyPath>SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile</q4:KeyPath>
          <q4:AdmSetting>false</q4:AdmSetting>
        </q4:RegistrySetting>
        <q4:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q4:KeyPath>SOFTWARE\Policies\Microsoft\WindowsFirewall</q4:KeyPath>
          <q4:AdmSetting>false</q4:AdmSetting>
        </q4:RegistrySetting>
        <q4:RegistrySetting>
          <GPO xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">
            <Identifier xmlns="http://www.microsoft.com/GroupPolicy/Types">{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}</Identifier>
            <Domain xmlns="http://www.microsoft.com/GroupPolicy/Types">TestDomain.Local</Domain>
          </GPO>
          <Precedence xmlns="http://www.microsoft.com/GroupPolicy/Settings/Base">1</Precedence>
          <q4:KeyPath>SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile</q4:KeyPath>
          <q4:AdmSetting>false</q4:AdmSetting>
        </q4:RegistrySetting>
      </Extension>
      <Name xmlns="http://www.microsoft.com/GroupPolicy/Settings">Registry</Name>
    </ExtensionData>
    <EventsDetails>
      <SinglePassEventsDetails ActivityId="{628cefe6-b3f1-4462-bd0a-3e1d51e18dc7}" ProcessingTrigger="Manual" ProcessingAppMode="Background" LinkSpeedInKbps="0" SlowLinkThresholdInKbps="500" DomainControllerName="DC1.TestDomain.Local" DomainControllerIPAddress="10.190.222.130" PolicyProcessingMode="None" PolicyElapsedTimeInMilliseconds="1247" ErrorCount="0" WarningCount="0">
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4004&lt;/EventID&gt;&lt;Version&gt;1&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;1&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:33.806352100Z'/&gt;&lt;EventRecordID&gt;1521458&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PolicyActivityId'&gt;{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}&lt;/Data&gt;&lt;Data Name='PrincipalSamName'&gt;MESHCLUST\DC1$&lt;/Data&gt;&lt;Data Name='IsMachine'&gt;1&lt;/Data&gt;&lt;Data Name='IsDomainJoined'&gt;true&lt;/Data&gt;&lt;Data Name='IsBackgroundProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsAsyncProcessing'&gt;false&lt;/Data&gt;&lt;Data Name='IsServiceRestart'&gt;false&lt;/Data&gt;&lt;Data Name='ReasonForSyncProcessing'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Starting manual processing of policy for computer MESHCLUST\DC1$.
Activity id: {628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5340&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:33.807187200Z'/&gt;&lt;EventRecordID&gt;1521459&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PolicyApplicationMode'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The Group Policy processing mode is Background.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:33.807442400Z'/&gt;&lt;EventRecordID&gt;1521460&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4114&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Attempting to retrieve the account information.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:33.807446100Z'/&gt;&lt;EventRecordID&gt;1521461&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4117&lt;/Data&gt;&lt;Data Name='Parameter'&gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system call to get account information.
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:33.808775100Z'/&gt;&lt;EventRecordID&gt;1521462&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4118&lt;/Data&gt;&lt;Data Name='Parameter'&gt;CN=DC1,OU=Domain Controllers,DC=MeshClust,DC=Local&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system call to get account information completed.
CN=DC1,OU=Domain Controllers,DC=MeshClust,DC=Local
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:33.808777300Z'/&gt;&lt;EventRecordID&gt;1521463&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4115&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Retrieved account information.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4326&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:33.808869600Z'/&gt;&lt;EventRecordID&gt;1521464&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Group Policy is trying to discover the Domain Controller information.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:33.808870500Z'/&gt;&lt;EventRecordID&gt;1521465&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4096&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Retrieving Domain Controller details.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.108871000Z'/&gt;&lt;EventRecordID&gt;1521466&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4119&lt;/Data&gt;&lt;Data Name='Parameter'&gt;DC1.TestDomain.Local&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making LDAP calls to connect and bind to Active Directory.
DC1.TestDomain.Local</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.111087600Z'/&gt;&lt;EventRecordID&gt;1521467&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4120&lt;/Data&gt;&lt;Data Name='Parameter'&gt;DC1.TestDomain.Local&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The LDAP call to connect and bind to Active Directory completed.
DC1.TestDomain.Local
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5308&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.111093000Z'/&gt;&lt;EventRecordID&gt;1521468&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='DCName'&gt;DC1.TestDomain.Local&lt;/Data&gt;&lt;Data Name='DCIPAddress'&gt;10.190.222.130&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Domain Controller details:
	Domain Controller Name : DC1.TestDomain.Local
	Domain Controller IP Address : 10.190.222.130</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5326&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.111094400Z'/&gt;&lt;EventRecordID&gt;1521469&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='DCDiscoveryTimeInMilliSeconds'&gt;313&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Group Policy successfully discovered the Domain Controller in 313 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5309&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.111704500Z'/&gt;&lt;EventRecordID&gt;1521470&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='MachineRole'&gt;3&lt;/Data&gt;&lt;Data Name='NetworkName'&gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Computer details:
	Computer role : 3
	Network name : </EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5310&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.111706300Z'/&gt;&lt;EventRecordID&gt;1521471&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PrincipalCNName'&gt;CN=DC1,OU=Domain Controllers,DC=MeshClust,DC=Local&lt;/Data&gt;&lt;Data Name='PrincipalDomainName'&gt;TestDomain.Local&lt;/Data&gt;&lt;Data Name='DCName'&gt;\\DC1.TestDomain.Local&lt;/Data&gt;&lt;Data Name='DCDomainName'&gt;TestDomain.Local&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Account details:
	Account Name : CN=DC1,OU=Domain Controllers,DC=MeshClust,DC=Local
	Account Domain Name : TestDomain.Local
	DC Name : \\DC1.TestDomain.Local
	DC Domain Name : TestDomain.Local</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5311&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.114487600Z'/&gt;&lt;EventRecordID&gt;1521472&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PolicyProcessingMode'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The loopback policy processing mode is "No loopback mode".</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4126&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.114489200Z'/&gt;&lt;EventRecordID&gt;1521473&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='IsMachine'&gt;true&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Group Policy receiving applicable GPOs from the domain controller.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4257&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.115794700Z'/&gt;&lt;EventRecordID&gt;1521474&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='IsMachine'&gt;true&lt;/Data&gt;&lt;Data Name='IsBackgroundProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsAsyncProcessing'&gt;true&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Starting to download policies.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5327&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.421606100Z'/&gt;&lt;EventRecordID&gt;1521475&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='NetworkBandwidthInKbps'&gt;0&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Estimated network bandwidth on one of the connections: 0 kbps.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5314&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.423863200Z'/&gt;&lt;EventRecordID&gt;1521476&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='BandwidthInkbps'&gt;0&lt;/Data&gt;&lt;Data Name='IsSlowLink'&gt;false&lt;/Data&gt;&lt;Data Name='ThresholdInkbps'&gt;500&lt;/Data&gt;&lt;Data Name='PolicyApplicationMode'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='LinkDescription'&gt;%%4113&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>A fast link was detected. The Estimated bandwidth is 0 kbps. The slow link threshold is 500 kbps.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.423917300Z'/&gt;&lt;EventRecordID&gt;1521477&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.429673900Z'/&gt;&lt;EventRecordID&gt;1521478&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}\gpt.ini
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.467637700Z'/&gt;&lt;EventRecordID&gt;1521479&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.469469200Z'/&gt;&lt;EventRecordID&gt;1521480&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\gpt.ini
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.469650100Z'/&gt;&lt;EventRecordID&gt;1521481&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationDescription'&gt;%%4131&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{6AC1786C-016F-11D2-945F-00C04fB984F9}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Making system calls to access specified file.
\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{6AC1786C-016F-11D2-945F-00C04fB984F9}\gpt.ini</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5017&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.470717700Z'/&gt;&lt;EventRecordID&gt;1521482&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='OperationElaspedTimeInMilliSeconds'&gt;0&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='OperationDescription'&gt;%%4132&lt;/Data&gt;&lt;Data Name='Parameter'&gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{6AC1786C-016F-11D2-945F-00C04fB984F9}\gpt.ini&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The system calls to access specified file completed.
\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{6AC1786C-016F-11D2-945F-00C04fB984F9}\gpt.ini
The call completed in 0 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5257&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.470754400Z'/&gt;&lt;EventRecordID&gt;1521483&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='IsMachine'&gt;true&lt;/Data&gt;&lt;Data Name='PolicyDownloadTimeElapsedInMilliseconds'&gt;359&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Successfully completed downloading policies.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5126&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.474397900Z'/&gt;&lt;EventRecordID&gt;1521484&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='IsMachine'&gt;true&lt;/Data&gt;&lt;Data Name='IsBackgroundProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsAsyncProcessing'&gt;false&lt;/Data&gt;&lt;Data Name='NumberOfGPOsDownloaded'&gt;3&lt;/Data&gt;&lt;Data Name='NumberOfGPOsApplicable'&gt;3&lt;/Data&gt;&lt;Data Name='GPODownloadTimeElapsedInMilliseconds'&gt;359&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Group Policy successfully got applicable GPOs from the domain controller.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5312&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.474833000Z'/&gt;&lt;EventRecordID&gt;1521485&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='DescriptionString'&gt;Firewall Config
Default Domain Policy
Default Domain Controllers Policy
&lt;/Data&gt;&lt;Data Name='GPOInfoList'&gt;&amp;lt;GPO ID="{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}"&amp;gt;&amp;lt;Name&amp;gt;Firewall Config&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;786444&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=MeshClust,DC=Local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\SysVol\TestDomain.Local\Policies\{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{B05566AC-FE9C-4368-BE01-7A4CBB6CBA11}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{31B2F340-016D-11D2-945F-00C04FB984F9}"&amp;gt;&amp;lt;Name&amp;gt;Default Domain Policy&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;196611&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://DC=MeshClust,DC=Local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{53D6AB1B-2488-11D1-A28C-00C04FB94F17}][{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}][{B1BE8D72-6EAC-11D2-A4EA-00C04F79F83A}{53D6AB1B-2488-11D1-A28C-00C04FB94F17}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{6AC1786C-016F-11D2-945F-00C04fB984F9}"&amp;gt;&amp;lt;Name&amp;gt;Default Domain Controllers Policy&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;65537&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;LDAP://OU=Domain Controllers,DC=MeshClust,DC=Local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;\\TestDomain.Local\sysvol\TestDomain.Local\Policies\{6AC1786C-016F-11D2-945F-00C04fB984F9}\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Extensions&amp;gt;[{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}]&amp;lt;/Extensions&amp;gt;&amp;lt;/GPO&amp;gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>List of applicable Group Policy objects:

Firewall Config
Default Domain Policy
Default Domain Controllers Policy
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5313&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.474853400Z'/&gt;&lt;EventRecordID&gt;1521486&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='DescriptionString'&gt;Local Group Policy
	Not Applied (Empty)
&lt;/Data&gt;&lt;Data Name='GPOInfoList'&gt;&amp;lt;GPO ID="Local Group Policy"&amp;gt;&amp;lt;Name&amp;gt;Local Group Policy&amp;lt;/Name&amp;gt;&amp;lt;Version&amp;gt;0&amp;lt;/Version&amp;gt;&amp;lt;SOM&amp;gt;Local&amp;lt;/SOM&amp;gt;&amp;lt;FSPath&amp;gt;C:\Windows\System32\GroupPolicy\Machine&amp;lt;/FSPath&amp;gt;&amp;lt;Reason&amp;gt;NOTAPPLIED-EMPTY&amp;lt;/Reason&amp;gt;&amp;lt;/GPO&amp;gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The following Group Policy objects were not applicable because they were filtered out :

Local Group Policy
	Not Applied (Empty)
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.494576400Z'/&gt;&lt;EventRecordID&gt;1521487&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4161&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Checking for Group Policy client extensions that are not part of the system.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.494721600Z'/&gt;&lt;EventRecordID&gt;1521488&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4163&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Service configuration update to standalone is not required and will be skipped.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5320&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.494722300Z'/&gt;&lt;EventRecordID&gt;1521489&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='InfoDescription'&gt;%%4165&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Finished checking for non-system extensions.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4016&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;1&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.495012100Z'/&gt;&lt;EventRecordID&gt;1521490&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='CSEExtensionId'&gt;{35378EAC-683F-11D2-A89A-00C04FBBCFA2}&lt;/Data&gt;&lt;Data Name='CSEExtensionName'&gt;Registry&lt;/Data&gt;&lt;Data Name='IsExtensionAsyncProcessing'&gt;false&lt;/Data&gt;&lt;Data Name='IsGPOListChanged'&gt;true&lt;/Data&gt;&lt;Data Name='GPOListStatusString'&gt;%%4102&lt;/Data&gt;&lt;Data Name='DescriptionString'&gt;Firewall Config
Default Domain Policy
&lt;/Data&gt;&lt;Data Name='ApplicableGPOList'&gt;&amp;lt;GPO ID="{8B7EF719-3FFF-437A-B318-E77A0ACB8FD9}"&amp;gt;&amp;lt;Name&amp;gt;Firewall Config&amp;lt;/Name&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{31B2F340-016D-11D2-945F-00C04FB984F9}"&amp;gt;&amp;lt;Name&amp;gt;Default Domain Policy&amp;lt;/Name&amp;gt;&amp;lt;/GPO&amp;gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Starting Registry Extension Processing.

List of applicable Group Policy objects: (Changes were detected.)

Firewall Config
Default Domain Policy
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5016&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;2&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.520682800Z'/&gt;&lt;EventRecordID&gt;1521491&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='CSEElaspedTimeInMilliSeconds'&gt;31&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='CSEExtensionName'&gt;Registry&lt;/Data&gt;&lt;Data Name='CSEExtensionId'&gt;{35378EAC-683F-11D2-A89A-00C04FBBCFA2}&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Completed Registry Extension Processing in 31 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;4016&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;1&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:34.538416500Z'/&gt;&lt;EventRecordID&gt;1521492&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='CSEExtensionId'&gt;{827D319E-6EAC-11D2-A4EA-00C04F79F83A}&lt;/Data&gt;&lt;Data Name='CSEExtensionName'&gt;Security&lt;/Data&gt;&lt;Data Name='IsExtensionAsyncProcessing'&gt;true&lt;/Data&gt;&lt;Data Name='IsGPOListChanged'&gt;true&lt;/Data&gt;&lt;Data Name='GPOListStatusString'&gt;%%4102&lt;/Data&gt;&lt;Data Name='DescriptionString'&gt;Default Domain Policy
Default Domain Controllers Policy
&lt;/Data&gt;&lt;Data Name='ApplicableGPOList'&gt;&amp;lt;GPO ID="{31B2F340-016D-11D2-945F-00C04FB984F9}"&amp;gt;&amp;lt;Name&amp;gt;Default Domain Policy&amp;lt;/Name&amp;gt;&amp;lt;/GPO&amp;gt;&amp;lt;GPO ID="{6AC1786C-016F-11D2-945F-00C04fB984F9}"&amp;gt;&amp;lt;Name&amp;gt;Default Domain Controllers Policy&amp;lt;/Name&amp;gt;&amp;lt;/GPO&amp;gt;&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Starting Security Extension Processing.

List of applicable Group Policy objects: (Changes were detected.)

Default Domain Policy
Default Domain Controllers Policy
</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5016&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;2&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.042189600Z'/&gt;&lt;EventRecordID&gt;1521493&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='CSEElaspedTimeInMilliSeconds'&gt;500&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='CSEExtensionName'&gt;Security&lt;/Data&gt;&lt;Data Name='CSEExtensionId'&gt;{827D319E-6EAC-11D2-A4EA-00C04F79F83A}&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Completed Security Extension Processing in 500 milliseconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;1502&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;1&lt;/Opcode&gt;&lt;Keywords&gt;0x8000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.053036800Z'/&gt;&lt;EventRecordID&gt;32762&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;System&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='SupportInfo1'&gt;1&lt;/Data&gt;&lt;Data Name='SupportInfo2'&gt;4183&lt;/Data&gt;&lt;Data Name='ProcessingMode'&gt;0&lt;/Data&gt;&lt;Data Name='ProcessingTimeInMilliseconds'&gt;1250&lt;/Data&gt;&lt;Data Name='DCName'&gt;\\DC1.TestDomain.Local&lt;/Data&gt;&lt;Data Name='NumberOfGroupPolicyObjects'&gt;3&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>The Group Policy settings for the computer were processed successfully. New settings from 3 Group Policy objects were detected and applied.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;8004&lt;/EventID&gt;&lt;Version&gt;1&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;2&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.054229000Z'/&gt;&lt;EventRecordID&gt;1521494&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PolicyElaspedTimeInSeconds'&gt;1&lt;/Data&gt;&lt;Data Name='ErrorCode'&gt;0&lt;/Data&gt;&lt;Data Name='PrincipalSamName'&gt;MESHCLUST\DC1$&lt;/Data&gt;&lt;Data Name='IsMachine'&gt;1&lt;/Data&gt;&lt;Data Name='IsConnectivityFailure'&gt;false&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Completed manual processing of policy for computer MESHCLUST\DC1$ in 1 seconds.</EventDescription>
        </EventRecord>
        <EventRecord>
          <EventXml>&lt;Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'&gt;&lt;System&gt;&lt;Provider Name='Microsoft-Windows-GroupPolicy' Guid='{AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9}'/&gt;&lt;EventID&gt;5315&lt;/EventID&gt;&lt;Version&gt;0&lt;/Version&gt;&lt;Level&gt;4&lt;/Level&gt;&lt;Task&gt;0&lt;/Task&gt;&lt;Opcode&gt;0&lt;/Opcode&gt;&lt;Keywords&gt;0x4000000000000000&lt;/Keywords&gt;&lt;TimeCreated SystemTime='2019-01-11T19:15:35.056988300Z'/&gt;&lt;EventRecordID&gt;1521495&lt;/EventRecordID&gt;&lt;Correlation ActivityID='{628CEFE6-B3F1-4462-BD0A-3E1D51E18DC7}'/&gt;&lt;Execution ProcessID='108' ThreadID='868'/&gt;&lt;Channel&gt;Microsoft-Windows-GroupPolicy/Operational&lt;/Channel&gt;&lt;Computer&gt;DC1.TestDomain.Local&lt;/Computer&gt;&lt;Security UserID='S-1-5-18'/&gt;&lt;/System&gt;&lt;EventData&gt;&lt;Data Name='PrincipalSamName'&gt;MESHCLUST\DC1$&lt;/Data&gt;&lt;Data Name='NextPolicyApplicationTime'&gt;5&lt;/Data&gt;&lt;Data Name='NextPolicyApplicationTimeUnit'&gt;%%4100&lt;/Data&gt;&lt;/EventData&gt;&lt;/Event&gt;</EventXml>
          <EventDescription>Next policy processing for MESHCLUST\DC1$ will be attempted in 5 minutes.</EventDescription>
        </EventRecord>
        <ExtensionProcessingTime>
          <ExtensionName>Registry</ExtensionName>
          <ExtensionGuid>{35378EAC-683F-11D2-A89A-00C04FBBCFA2}</ExtensionGuid>
          <ElapsedTimeInMilliseconds>31</ElapsedTimeInMilliseconds>
          <ProcessedTimeStamp>2019-01-11T11:15:34.5206828-08:00</ProcessedTimeStamp>
        </ExtensionProcessingTime>
        <ExtensionProcessingTime>
          <ExtensionName>Security</ExtensionName>
          <ExtensionGuid>{827D319E-6EAC-11D2-A4EA-00C04F79F83A}</ExtensionGuid>
          <ElapsedTimeInMilliseconds>500</ElapsedTimeInMilliseconds>
          <ProcessedTimeStamp>2019-01-11T11:15:35.0421896-08:00</ProcessedTimeStamp>
        </ExtensionProcessingTime>
        <ExtensionProcessingTime>
          <ExtensionName>Group Policy Infrastructure</ExtensionName>
          <ExtensionGuid>{00000000-0000-0000-0000-000000000000}</ExtensionGuid>
          <ElapsedTimeInMilliseconds>716</ElapsedTimeInMilliseconds>
          <ProcessedTimeStamp>2019-01-11T11:15:35.054229-08:00</ProcessedTimeStamp>
        </ExtensionProcessingTime>
      </SinglePassEventsDetails>
    </EventsDetails>
  </ComputerResults>
</Rsop>
'@ )
}
# combines values exxtracted from nodes like
# $o.'Rsop'.'ComputerResults'.'ExtensionData'.'Extension'.'DomainProfile'.'EnableFirewall'
# $o.'Rsop'.'ComputerResults'.'ExtensionData'.'Extension'.'PiblicProfile'.'EnableFirewall'
# Uses Microsoft wvariant of method unknown syntax:

$extension_element = $o.'Rsop'.'ComputerResults'.'ExtensionData'.'Extension'
$profiles = @('Domain', 'Public' , 'Private')

$firewall_status = @{}
$profiles | foreach-object {
  $profile = $_
  $firewall_status[$profile] = $false
}
$profiles | foreach-object {
  $profile = $_
  $profile_element_name = ('{0}Profile' -f $_)
  if ($debug_run) {
    # write to STDERR colorless
    [System.Console]::Error.WriteLine( $profile_element_name )
  }
  # NOTE: returned is an System.Object[] array (hack around is possible)
  if ($debug_run) {
    $t = $extension_element.GetNamespaceOfPrefix('q3').GetType()
    write-output $t.Name
    write-output $t.Namespace
  }

  $namespace = $extension_element.GetNamespaceOfPrefix('q3') -join ''
  if ([String]::IsNullOrempty($namespace) -or ($nameapace -eq $null)) {
    $namespace = 'http://www.microsoft.com/GroupPolicy/Settings/WindowsFirewall'
  }
  if ($debug_run) {
    # write to STDERR colorless
    [System.Console]::Error.WriteLine( $namespace )
  }
  $profile_element = $extension.GetElementsByTagName($profile_element_name, $namespace)
  $enable_firewall_element =  $profile_element.'EnableFirewall'
  $firewall_status[$profile] = [Boolean]($enable_firewall_element.Value)
  if ($debug_run) {
    # write to STDERR colorless
    [System.Console]::Error.WriteLine(  $firewall_status[$profile] )
  }

}

$site=  $o.'Rsop'.'UserResults'.'Site'
$firewall_status_summary = $true

[Boolean[]]($firewall_status.Values) |
ForEach-Object {
  $firewall_status_value = $_
  $firewall_status_summary = [Boolean]($firewall_status_summary -band $firewall_status_value)
}
# No true ternary lexic in Powershell grammar
# home-brewed workaround
# https://github.com/nightroman/PowerShellTraps/tree/master/Basic/Missing-ternary-operator
# does not work well in complex expressions either:
# write-output ('{0} GPO: Firewall Config - {1}' -f $site, (if($firewall_status_summary){'FirewallEnabled'} else { 'FirewallDisabled'}))
if ($debug_run) {
  # write to STDERR but colorless
  [System.Console]::Error.WriteLine( $firewall_status_summary )
}

$status_verbose = if($firewall_status_summary){'FirewallEnabled'} else { 'FirewallDisabled'}
write-output ('{0} GPO: Firewall Config - {1}' -f $site, $status_verbose)
