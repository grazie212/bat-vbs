@echo off
REM ============================================================================
REM batch-name: ffftp_tool.bat
REM about: FFFTPを便利に使うバッチ
REM ============================================================================
setlocal
cd /d %~dp0

REM ========================================
REM === メインシーケンス
call :INIT
call :INIT-INDIVIDUAL

REM ffftp起動
call %commonLogBat% %cmdName% INFO [%userID%]:FFFTP作業開始
call "C:\product\ffftp\FFFTP.exe" -n "%initFile%"

goto END-RTN
REM === メインシーケンスEND
REM ========================================

REM ========================================
REM === バッチの必須変数
:INIT
    set cmdName=%~n0
    set dateStamp=%date:/=%
    set hostname=%COMPUTERNAME%
    set logName=%cmdName%_%hostname%_%dateStamp%.log
    set creDir=%~dp0
    set logDir=%creDir%logs
    set commonLogBat=%creDir%common_log.bat
    
exit /b

REM ========================================
REM === バッチの個別変数
:INIT-INDIVIDUAL
    call :USERID-SELECT
    set initFile=%creDir%\config\FFFTP.ini
exit /b

REM ========================================
REM === ユーザID選択
:USERID-SELECT
    echo *****************************************************************
    echo menu
    echo -----------------------------------------------------------------
    echo 01:user01
    echo 02:user02
    echo 03:user03
    echo 04:user04
    echo *****************************************************************
    set userIDselect=""
    set /P userIDselect="ユーザIDを入力してください[Ex:01]："
    if %userIDselect%==01 ( 
        set userID=user01
    ) else if %userIDselect%==02 (
        set userID=user02
    ) else if %userIDselect%==03 (
        set userID=user03
    ) else if %userIDselect%==04 ( 
        set userID=user04
    ) else (
        cls
        call %commonLogBat% %cmdName% ERROR 選択した[%userIDselect%]のユーザは登録されていません
        goto USERID-SELECT
    )
    cls
exit /b

REM ========================================
REM === END-RTN
:END-RTN
    call %commonLogBat% %cmdName% INFO [%userID%]:FFFTP作業終了
    echo キーを押すと終了します
    set /P input=
    set input=
    
endlocal
exit /b 0