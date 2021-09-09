@echo off

title MongoDB Windows Backup Script

set /p MONGO_HOST=Enter the host / ip address of the mongo server: 
echo.
set /p MONGO_PORT=Enter the port for the mongo server: 
echo.
set /p MONGO_USERNAME=Enter the username used to connect to the mongo server: 
echo.
set /p MONGO_PASSWORD=Enter the password for the specified mongo user: 
echo.
set MONGO_CONNECTION_URL=mongodb://%MONGO_USERNAME%:%MONGO_PASSWORD%@%MONGO_HOST%:%MONGO_PORT%

echo Creating backups folder if it does not already exist...
echo.
if not exist ".\backups" mkdir ".\backups"

echo Generating backup name...
for /f "delims=" %%i in ('powershell -command "Get-date -format yyyy-MM-dd_HH-mm-ss_fffffff"') do set BACKUP_NAME=%%i

echo Creating backup: %BACKUP_NAME%
echo Please wait as this may take several minutes...
echo.
mongodump --uri="%MONGO_CONNECTION_URL%" -o ".\backups\mongodb-%BACKUP_NAME%" --quiet
mongodump --uri="%MONGO_CONNECTION_URL%" --archive=".\backups\mongodb-%BACKUP_NAME%\mongodb-archive-file" --quiet
echo.

echo Check the above output for any errors.
echo.

echo You must use the following command to recover from the backup:
echo mongorestore --archive '.\backups\mongodb-%BACKUP_NAME%\mongodb-archive-file'
echo Remember to include any additional parameters required by the mongorestore command.

pause
