ECHO OFF
CLS

@ECHO 0. Define variables.
SET counter=0
SET /a timeout=20
SET /a limit=60
SET Process_ID=892970
SET Steam_PATH="C:\Program Files (x86)\Steam\Steam.exe"
SET Process_Name="valheim.exe"
CALL :defineDateTime

ECHO 1. Open Process %Process_Name% at %Date_Time%.
%Steam_PATH% steam://rungameid/%Process_ID%

ECHO 2. Fetch and pull from git folder.
GIT fetch
GIT pull

ECHO 3. Wait until process is closed.
GOTO waitForProcess

:waitForProcess
    tasklist /FI "IMAGENAME eq %Process_Name%" | find /I %Process_Name% >nul

    if %ERRORLEVEL% == 0 (
        TIMEOUT /t %timeout% /nobreak >nul

        :: i.e.: Check every 20 seconds if process still alive, and commit every 20 minutes (1200secs), 20seconds * 60limit = 1200secs.
        if %counter% EQU %limit% (
            CALL :defineDateTime
            CALL :createCommit
            SET /a counter=0
        ) else (
            SET /a counter+=1
        )
        GOTO waitForProcess
    )
    CALL :createCommit
    GOTO :EOF

:createCommit
    ECHO Commiting at %Date_Time%.
    SET updates=
    FOR /f %%i in ('git status --short') DO SET updates=%%i

    if NOT [%updates%] == [] (
        GIT add .
        GIT commit -m "Auto-Commit at %Date_Time%"
        GIT push
    )

:defineDateTime
    SET Date_Time=%Date:~5%-%Time:~0,8%