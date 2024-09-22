@ECHO OFF
CLS

SET Game_ID=70600
@REM SET Game_ID=892970
SET Date_Time "%Date:~5%-%Time:~0,8%"
SET Steam_PATH="C:\Program Files (x86)\Steam\Steam.exe"
SET processName="Spotify.exe"

:waitForProcess
tasklist /FI "IMAGENAME eq Spotify.exe" | find /I "Spotify.exe" >nul
if %ERRORLEVEL% == 0 (
    rem Process is running, wait a bit and check again
    timeout /t 5 /nobreak >nul
    goto waitForProcess
)

ECHO Pull latest changes.
GIT fetch
GIT pull

ECHO Open Game.
%Steam_PATH% steam://rungameid/%Game_ID%

ECHO Push latest changes.
@REM GIT add .
@REM GIT commit -m "Commit "
@REM GIT push