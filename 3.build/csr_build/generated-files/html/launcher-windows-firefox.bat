@echo off&setlocal

:: set some convenience variables
for %%i in ("%~dp0.") do set "this_dir=%%~fi"
set "docpath=file://%this_dir%\index.html"
set "launcher_data=%this_dir%\.launcher_data"

:: Launch using Firefox using a pre-configured profile
:: This profile sets the user preference:
::     security.fileuri.strict_origin_policy = false
:: This setting works around a security policy that prevents dynamic content to be loaded
:: See this page for more details:
::    https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS/Errors/CORSRequestNotHttp
start "" firefox -profile %launcher_data%\firefox %docpath%
