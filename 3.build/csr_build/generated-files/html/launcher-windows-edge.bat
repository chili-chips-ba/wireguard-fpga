@echo off&setlocal

:: set some convenience variables
for %%i in ("%~dp0.") do set "this_dir=%%~fi"
set "docpath=file://%this_dir%\index.html"
set "launcher_data=%this_dir%\.launcher_data"

:: Launch using Edge using some special flags:
::     --allow-file-access-from-files
::         This flag works around a security policy that prevents dynamic content to be loaded
::         See this page for more details:
::             https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS/Errors/CORSRequestNotHttp
::     --user-data-dir
::         If edge already has a session open, then it will re-use that session and the CORS workaround
::         will not take effect. Forcing edge to use a temporary alternate user data directory
::         is a hacky way to force edge to launch a fresh session
:: NOTE: Edge may prompt you with a few "new user" popups the first time, because
:: the data dir is uninitialized. I could not figure out a clean way to disable this
start "" msedge --allow-file-access-from-files --user-data-dir=%launcher_data%\msedge %docpath%
