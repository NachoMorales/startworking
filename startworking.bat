@echo off
setlocal enabledelayedexpansion

:: checkProject
IF [%1]==[] (
    echo "Modo de uso: startworking <NombreProyecto> <NombreApp; default: all; 'n': ninguna> <NombreSegundaApp; opcional>"
    exit /b
)
set PROJECT=%1
cd C:\Users\%USERNAME%\Desktop\projects\%PROJECT%
IF %ERRORLEVEL% neq 0 echo "No se encontró el proyecto '%PROJECT%'" & exit /b %ERRORLEVEL%


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
                set /p FIRSTCOMMAND="Ingresar comando para iniciar %FIRSTAPP%: "
            ) ELSE (
                echo No se encontro la carpeta '%FIRSTAPP%' en el proyecto %PROJECT%
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
                set /p SECONDCOMMAND="Ingresar comando para iniciar %SECONDAPP%: "
            ) ELSE (
                echo No se encontro la carpeta '%SECONDAPP%' en el proyecto %PROJECT%
                exit /b
            )
    )
)
goto :askPull


:askVSCode
    set /p "VSCODE=Abrir vscode en: "
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
        echo No se encontro la carpeta '%VSCODE%'. Por favor introduzca una carpeta valida.
        goto :askVSCode
    )


:askPull
    set /p "GITPULL=Hacer pull (y/n)? "
    IF NOT "%GITPULL%"=="y" (
        IF NOT "%GITPULL%"=="n" (
            echo No se acepta: '%GITPULL%'. Solo se acepta 'y' o 'n'
            goto :askPull
        )
    )


:startDiscord
    start %LocalAppData%\Discord\Update --processStart Discord.exe

:: startGitBash
    IF "%GITPULL%"=="y" (
        :: IMPORTANTE: hacer git add y git commit antes del pull?
        start "" "%PROGRAMFILES%\Git\bin\sh.exe" --login -i -l -c "sh -c 'git pull; exec sh'"
    ) ELSE (
        start "" "%PROGRAMFILES%\Git\bin\sh.exe" --login
    )

:: openVSCode
    IF DEFINED VSCODE (
        IF "%VSCODE%"=="n" (
            goto :handleApps
        )
        ::start cmd /C "cd C:\Users\%USERNAME%\Desktop\projects\%PROJECT%\%VSCODE% & code ."
        code C:\Users\%USERNAME%\Desktop\projects\%PROJECT%\%VSCODE%
    ) ELSE (
        IF NOT "%FIRSTAPP%"=="n" (
            ::start cmd /C "cd C:\Users\%USERNAME%\Desktop\projects\%PROJECT%\%FIRSTAPP% & code ."
            code C:\Users\%USERNAME%\Desktop\projects\%PROJECT%\%FIRSTAPP%
        )
        IF DEFINED SECONDAPP (
            ::start cmd /C "cd C:\Users\%USERNAME%\Desktop\projects\%PROJECT%\%SECONDAPP% & code ."
            code C:\Users\%USERNAME%\Desktop\projects\%PROJECT%\%SECONDAPP%
        )
    )


:handleApps
    IF NOT DEFINED FIRSTAPP (
        goto :loadAllApps
    ) ELSE (
        IF "%FIRSTAPP%"=="api" (
            goto :runFirstApp
        ) ELSE (
            IF "%FIRSTAPP%"=="n" (
                goto :startPostman
            ) ELSE (
                goto :runAPI
            )
        )
    )


:loadAllApps
    cd C:\Users\%USERNAME%\Desktop\projects\%PROJECT%
    for /f %%f in ('dir /a:d /b .') do (
        IF NOT "%%f"==".git" (
            cd C:\Users\%USERNAME%\Desktop\projects\%PROJECT%
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
                        set /p "COMMAND=Ingresar comando para inicar %%f: "
                        start cmd /k "cd %%f & !COMMAND!"
                    )
                )
            )
        )
    )
    goto :startPostman


:runAPI
    cd api
    IF %ERRORLEVEL% neq 0 goto :runFirstApp
    start cmd /k "npm start"
    cd ..


:runFirstApp
    start cmd /k "cd %FIRSTAPP% & %FIRSTCOMMAND%"
    IF "%FIRSTAPP%"=="adm" (
        start http://localhost:4200
    )

:: runSecondApp
    IF NOT DEFINED SECONDAPP (
        goto :startPostman
    )

    start cmd /k "cd %SECONDAPP% & %SECONDCOMMAND%"
    IF "%SECONDAPP%"=="adm" (
        start http://localhost:4200
    )


:startPostman
    start %LocalAppData%\Postman\Postman



    exit