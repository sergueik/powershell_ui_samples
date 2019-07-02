CREATE PROCEDURE sp_CreateAlert(@Message varchar(255), @Url varchar(255),@Voice varchar(255)) AS
DECLARE @FS int, @OLEResult int, @FileID int, @FileName varchar(255),@Content varchar(1000)

--Create Temp File Name
set @FileName = 'c:\myalerts\queue\' + CAST(newid() AS char(36)) +'.txt'

--Create Alert Structure
set @Content = @Message+'|'+@Url+'|'+@Voice

--Use FileSystemObject to create alert file
EXECUTE @OLEResult = sp_OACreate 'Scripting.FileSystemObject', @FS OUT
IF @OLEResult <> 0 PRINT 'Scripting.FileSystemObject'

--Open a file
execute @OLEResult = sp_OAMethod @FS, 'OpenTextFile', @FileID OUT, @FileName, 8, 1
IF @OLEResult <> 0 PRINT 'OpenTextFile'

--Write Alert Message to file
execute @OLEResult = sp_OAMethod @FileID, 'WriteLine', Null, @Content
IF @OLEResult <> 0 PRINT 'WriteLine'

--Clean up
EXECUTE @OLEResult = sp_OADestroy @FileID
EXECUTE @OLEResult = sp_OADestroy @FS

GO

--Create Trigger on Customers Table in Northwind Database
CREATE TRIGGER DataChanged ON Customers
FOR INSERT, UPDATE, DELETE
AS EXEC sp_CreateAlert 'Customer Changed','http://www.microsoft.com','en-UK_male'

GO
