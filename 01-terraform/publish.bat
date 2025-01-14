@echo off
rem #====================================================================================================
rem # set session-id and management IP variables
rem #====================================================================================================
for /l %%l in (2,1,2) do @for /f tokens^=3*^ delims^=^" %%a in ('findstr /n /r "^" sid.json ^| findstr /r "^%%l:"') do set "varsid=%%b"
for /l %%l in (2,1,2) do @for /f tokens^=1*^ delims^=^" %%a in ('findstr /n /r "^" main.tf ^| findstr /r "^%%l:"') do set "varmgmtip=%%b

rem #====================================================================================================
rem # Publish and set task-id in variable %vartask-id:~16,43%
rem # (https://%varmgmtip%/web_api/publish)
rem #====================================================================================================
curl -s -k -H "Content-Type: application/json" -H "X-chkp-sid: %varsid:~0,43%" -X POST -d "{}" https://%varmgmtip%/web_api/publish > task-id.json

rem #====================================================================================================
rem # Check Task and loop every 2 seconds until vraiable %varstatus:~4,9% is status = succeeded
rem # (https://%varmgmtip%/web_api/show-task)
rem #====================================================================================================
:taskloop
curl -s -k -H "Content-Type: application/json" -H "X-chkp-sid: %varsid:~0,43%" -X POST -d "@task-id.json" https://%varmgmtip%/web_api/show-task > status.json
for /l %%l in (5,1,5) do @for /f tokens^=2*^ delims^=^" %%a in ('findstr /n /r "^" status.json ^| findstr /r "^%%l:"') do set "varstatus=%%b
more status.json
timeout 2 /nobreak
if "%varstatus:~4,9%" NEQ "succeeded" goto taskloop

rem #====================================================================================================
rem # Logout and closing the session 
rem # (https://$varMgtIP/web_api/Logout)
rem #====================================================================================================
rem curl -s -k -H "Content-Type: application/json" -H "X-chkp-sid: %varsid:~0,43%" -X POST -d "{}" https://%varmgmtip%/web_api/logout

rem #====================================================================================================
rem #remove temp files
rem #====================================================================================================
del task-id.json
del status.json
