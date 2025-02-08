@REM credit: Adriwin
@echo off
setlocal enabledelayedexpansion

:ask_action
    set "action="
    set /p "action=Enter action (create c/extract e/quit q): "
    if /i "%action%"=="create" goto create
    if /i "%action%"=="c" goto create
    if /i "%action%"=="extract" goto extract
    if /i "%action%"=="e" goto extract
    if /i "%action%"=="quit" exit
    if /i "%action%"=="q" exit
    echo Error: Invalid action.
    goto ask_action

:extract
    :extract_ask_source
    set "source="
    set /p "source=Enter folder containing .bundle files: "
    if "%source%"=="" (
        echo Error: No input provided.
        goto ask_source
    )
    if not exist "%source%\" (
        echo Error: Folder "%source%" does not exist.
        goto ask_source
    )

    :extract_ask_dest
    set "dest="
    set /p "dest=Enter destination folder for extraction: "
    if "%dest%"=="" (
        echo Error: No input provided.
        goto ask_dest
    )
    mkdir "%dest%" 2> nul

    echo Scanning "%source%" for _AT.bundle files...
    for %%F in ("%source%\*.bundle") do (
        set "filename=%%~nF"
        echo Extracting "%%~nxF"...
        mkdir "%dest%\!filename!" 2> nul
        yap e "%%F" "%dest%\!filename!"
    )
    echo Done! Extracted files saved to "%dest%"
    pause
    goto ask_action

:create
    :create_ask_source
    set "source="
    set /p "source=Enter folder containing extracted bundle folders: "
    if "%source%"=="" (
        echo Error: No input provided.
        goto ask_source
    )
    if not exist "%source%\" (
        echo Error: Folder "%source%" does not exist.
        goto ask_source
    )

    :create_ask_dest
    set "dest="
    set /p "dest=Enter output folder for new bundle: "
    if "%dest%"=="" (
        echo Error: No input provided.
        goto ask_dest
    )
    mkdir "%dest%" 2> nul

    echo Scanning "%source%" for bundle folders...
    for /D %%F in ("%source%\*") do (
        if exist "%%F\.meta.yaml" (
            echo Creating bundle for "%%~nxF"...
            yap c "%%F" "%dest%\%%~nxF.bundle"
        ) else (
            echo Skipping "%%~nxF" (missing .meta.yaml)
        )
    )

    echo Done! New bundles saved to "%dest%"
    pause
    goto ask_action

set "action="
goto ask_action