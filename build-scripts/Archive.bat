set "str=%~1"
cd %CI_PROJECT_DIR%
"C:\Program Files\7-Zip\7z.exe" a PROJECT_NAME%str%.zip %CI_PROJECT_DIR%\Release\*