-- Enable xp_cmdshell (required to list files from disk using DIR command)
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;
GO


-- Drop existing procedure if it already exists
IF OBJECT_ID('dbo.Restore_Backups', 'P') IS NOT NULL
    DROP PROCEDURE dbo.Restore_Backups;
GO

-- Create procedure to restore all bak files
CREATE PROCEDURE dbo.Restore_Backups
    @bakPath NVARCHAR(255),      -- Source folder containing .bak files
    @targetPath NVARCHAR(255)    -- Target folder to store MDF and LDF files
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare variables for file handling
    DECLARE @cmd NVARCHAR(1000), @filename NVARCHAR(255), @restoreCmd NVARCHAR(MAX);
    DECLARE @dir TABLE (filename NVARCHAR(255));  -- Table to store file list from directory


    -- Use xp_cmdshell to list bak files in the folder 
    SET @cmd = 'dir /b "' + @bakPath + '\*.bak"';
    INSERT INTO @dir EXEC xp_cmdshell @cmd;

    -- Remove invalid rows
    DELETE FROM @dir WHERE filename IS NULL OR filename NOT LIKE '%.bak';

    -- Cursor to loop through each .bak file
    DECLARE cur CURSOR FOR SELECT filename FROM @dir;
    OPEN cur;
    FETCH NEXT FROM cur INTO @filename;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Full path to .bak file
        DECLARE @full NVARCHAR(500) = @bakPath + '\' + @filename;

        -- Use filename (without .bak) as database name
        DECLARE @db NVARCHAR(255) = REPLACE(@filename, '.bak', '');

        -- Define table for FILELISTONLY 
        DECLARE @filelist TABLE (
            LogicalName NVARCHAR(128),
            PhysicalName NVARCHAR(260),
            Type CHAR(1),
            FileGroupName NVARCHAR(128),
            Size BIGINT,
            MaxSize BIGINT,
            FileId INT,
            CreateLSN NUMERIC(25,0),
            DropLSN NUMERIC(25,0),
            UniqueId UNIQUEIDENTIFIER,
            ReadOnlyLSN NUMERIC(25,0),
            ReadWriteLSN NUMERIC(25,0),
            BackupSizeInBytes BIGINT,
            SourceBlockSize INT,
            FileGroupId INT,
            LogGroupGUID UNIQUEIDENTIFIER,
            DifferentialBaseLSN NUMERIC(25,0),
            DifferentialBaseGUID UNIQUEIDENTIFIER,
            IsReadOnly BIT,
            IsPresent BIT,
            TDEThumbprint VARBINARY(32),
            SnapshotUrl NVARCHAR(MAX)
        );

        BEGIN TRY

            -- Get logical names of MDF/LDF files from .bak
            SET @cmd = 'RESTORE FILELISTONLY FROM DISK = ''' + @full + '''';
            INSERT INTO @filelist EXEC (@cmd);

            -- Begin building RESTORE DATABASE command
            SET @restoreCmd = 'RESTORE DATABASE [' + @db + '] FROM DISK = ''' + @full + ''' WITH ';

            -- Add MOVE clause for each logical file 
            SELECT @restoreCmd += 'MOVE ''' + LogicalName + ''' TO ''' + @targetPath + '\' +
                @db + CASE WHEN Type = 'L' THEN '_log.ldf' ELSE '.mdf' END + ''', '
            FROM @filelist;

            -- Remove trailing comma, then finalize the restore command
            SET @restoreCmd = LEFT(@restoreCmd, LEN(@restoreCmd) - 1);
            SET @restoreCmd += ', REPLACE, RECOVERY';

            -- Output and execute the restore command
            PRINT 'Restoring: ' + @db;
            EXEC (@restoreCmd);
        END TRY
        BEGIN CATCH
            -- Catch and display errors per file, but continue with next
            PRINT 'Error restoring ' + @filename + ': ' + ERROR_MESSAGE();
        END CATCH

        -- Fetch next file in directory
        FETCH NEXT FROM cur INTO @filename;
    END

    -- Close cursor
    CLOSE cur;
    DEALLOCATE cur;
END
GO

-- Execute the procedure to restore all .bak files from given folder
EXEC Restore_Backups
    @bakPath = 'E:\Rakshitha\NewBackup',
    @targetPath = 'E:\Rakshitha\RestoredDB';
