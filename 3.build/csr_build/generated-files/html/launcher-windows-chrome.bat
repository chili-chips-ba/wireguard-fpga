@echo off&setlocal

:: set some convenience variables
for %%i in ("%~dp0.") do set "this_dir=%%~fi"
set "docpath=file://%this_dir%\index.html"
set "launcher_data=%this_dir%\.launcher_data"

:: Launch using Chrome using some special flags:
::     --allow-file-access-from-files
::         This flag works around a security policy that prevents dynamic content to be loaded
::         See this page for more details:
::             https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS/Errors/CORSRequestNotHttp
::     --user-data-dir
::         If chrome already has a session open, then it will re-use that session and the CORS workaround
::         will not take effect. Forcing chrome to use a temporary alternate user data directory
::         is a hacky way to force chrome to launch a fresh session
start "" chrome --allow-file-access-from-files --user-data-dir=%launcher_data%\chrome %docpath%
