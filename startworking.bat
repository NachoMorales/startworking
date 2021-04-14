@echo off
setlocal enabledelayedexpansion

@REM !IMPORTANT: set this variable to the root folder of your projects
:projectFolder
    set MAINFOLDER=C:\Users\%USERNAME%\Desktop\projects

:: checkProject
IF [%1]==[] (
    echo "Usage: startworking <ProjectName> <AppFolder; default: all; 'n': none> <SecondAppFolder; optional>"
    exit /b
)
set PROJECT=%1

cd %MAINFOLDER%\%PROJECT%
IF %ERRORLEVEL% neq 0 echo "Project '%PROJECT%' not found." & exit /b %ERRORLEVEL%


:: checkFirstApp
IF [%2]==[] (
    goto :askVSCode
)
set FIRSTAPP=%2

IF "%FIRSTAPP%"=="n" (
    goto :askVSCode
)

IF "%FIRSTAPP%"=="adm" (
    set FIRSTCOMMAND=ng serve
) ELSE (
    IF "%FIRSTAPP%"=="app" (
        set FIRSTCOMMAND=ionic s
    ) ELSE (
        IF "%FIRSTAPP%"=="api" (
            set FIRSTCOMMAND=npm start
        ) ELSE (
            for /f %%f in ('dir /a:d /b .') do (
                IF "%%f"=="%FIRSTAPP%" (
                    set FIRSTAPPISVALID=si
                )
            )
            IF DEFINED FIRSTAPPISVALID (
                set /p FIRSTCOMMAND="Enter command to start '%FIRSTAPP%': "
            ) ELSE (
                echo '%FIRSTAPP%' folder not found in '%PROJECT%'
                exit /b
            )
        )
    )
)


:: checkSecondApp
IF [%3]==[] (
    goto :askPull
)
set SECONDAPP=%3

IF "%SECONDAPP%"=="adm" (
    set SECONDCOMMAND=ng serve
) ELSE (
    IF "%SECONDAPP%"=="app" (
        set SECONDCOMMAND=ionic s
    ) ELSE (
        for /f %%f in ('dir /a:d /b .') do (
                IF "%%f"=="%SECONDAPP%" (
                    set SECONDAPPISVALID=si
                )
            )
            IF DEFINED SECONDAPPISVALID (
                set /p SECONDCOMMAND="Enter command to start '%SECONDAPP%': "
            ) ELSE (
                echo No se encontro la carpeta '%SECONDAPP%' en el proyecto %PROJECT%
                exit /b
            )
    )
)
goto :askPull


:askVSCode
    set /p "VSCODE=Open VSCode in: "
    set "VALID="

    IF "%VSCODE%"=="." (
        set "VALID=true"
    )

    IF "%VSCODE%"=="n" (
        set "VALID=true"
    )

    for /f %%f in ('dir /a:d /b .') do (
        IF "%%f"=="%VSCODE%" (
            set "VALID=true"
        )
    )

    IF NOT DEFINED VALID (
        echo '%VSCODE%' folder not found. Please enter a valid folder.
        goto :askVSCode
    )


:askPull
    set /p "GITPULL=Git Pull (y/n)? "
    IF NOT "%GITPULL%"=="y" (
        IF NOT "%GITPULL%"=="n" (
            echo Input rejected. Only 'y' or 'n' is accepted.
            goto :askPull
        )
    )


:startDiscord
    start %LocalAppData%\Discord\Update --processStart Discord.exe

:: startGitBash
    IF "%GITPULL%"=="y" (
        start "" "%PROGRAMFILES%\Git\bin\sh.exe" --login -i -l -c "sh -c 'git pull; exec sh'"
    ) ELSE (
        start "" "%PROGRAMFILES%\Git\bin\sh.exe" --login
    )

:: openVSCode
    IF DEFINED VSCODE (
        IF "%VSCODE%"=="n" (
            goto :handleApps
        ) ELSE (
            start cmd /C "code %MAINFOLDER%\%PROJECT%\%VSCODE%"
        )
    ) ELSE (
        IF NOT "%FIRSTAPP%"=="n" (
            start cmd /C "code %MAINFOLDER%\%PROJECT%\%FIRSTAPP%"
        )
        IF DEFINED SECONDAPP (
            start cmd /C "code %MAINFOLDER%\%PROJECT%\%SECONDAPP%"
        )
    )


:handleApps
    IF NOT DEFINED FIRSTAPP (
        goto :loadAllApps
    ) ELSE (
        IF "%FIRSTAPP%"=="api" (
            goto :runApps
        ) ELSE (
            IF "%FIRSTAPP%"=="n" (
                goto :startDiscord
            ) ELSE (
                goto :runAPI
            )
        )
    )


:loadAllApps
    for /f %%f in ('dir /a:d /b .') do (
        IF NOT "%%f"==".git" (
            IF NOT "%%f"=="adm" (
                IF NOT "%%f"=="api" (
                    IF NOT "%%f"=="app" (
                        set /p "COMMAND%%f=Enter command to start '%%f': "
                    )
                )
            )
        )
    )

    for /f %%f in ('dir /a:d /b .') do (
        IF NOT "%%f"==".git" (
            :: edit
            IF "%%f"=="adm" (
                start cmd /k "cd %%f & ng serve"
                start http://localhost:4200
            ) ELSE (
                IF "%%f"=="api" (
                    start cmd /C "cd %%f & npm start"
                ) ELSE (
                    IF "%%f"=="app" (
                        start cmd /k "cd %%f & ionic s"
                    ) ELSE (
                        start cmd /k "cd %%f & !COMMAND%%f!"
                    )
                )
            )
        )
    )
    goto :startDiscord


:runAPI
    cd api
    IF %ERRORLEVEL% neq 0 goto :runApps
    start cmd /k "npm start"
    cd ..


:runApps
    start cmd /k "cd %FIRSTAPP% & %FIRSTCOMMAND%"
    IF "%FIRSTAPP%"=="adm" (
        start http://localhost:4200/
    )

    IF NOT DEFINED SECONDAPP (
        goto :startDiscord
    )

    start cmd /k "cd %SECONDAPP% & %SECONDCOMMAND%"
    IF "%SECONDAPP%"=="adm" (
        start http://localhost:4200/
    )


:startDiscord
    start %LocalAppData%\Discord\Update --processStart Discord.exe

:: startGitBash
    IF "%GITPULL%"=="y" (
        start "" "%PROGRAMFILES%\Git\bin\sh.exe" --login -i -l -c "sh -c 'git pull; exec sh'"
    ) ELSE (
        start "" "%PROGRAMFILES%\Git\bin\sh.exe" --login
    )

:: openVSCode
    IF DEFINED VSCODE (
        IF "%VSCODE%"=="n" (
            goto :startPostman
        ) ELSE (
            start cmd /C "code %MAINFOLDER%\%PROJECT%\%VSCODE%"
        )
    ) ELSE (
        IF NOT "%FIRSTAPP%"=="n" (
            start cmd /C "code %MAINFOLDER%\%PROJECT%\%FIRSTAPP%"
        )
        IF DEFINED SECONDAPP (
            start cmd /C "code %MAINFOLDER%\%PROJECT%\%SECONDAPP%"
        )
    )


:startPostman
    start %LocalAppData%\Postman\Postman


exit