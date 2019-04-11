@echo off
REM ============================================================================
REM batch-name: proxy_ie.bat
REM about: IEのプロキシを設定してくれるバッチ
REM ============================================================================
setlocal ENABLEDELAYEDEXPANSION
cd /d %~dp0

REM ========================================
REM === メインシーケンス
call :INIT
call :INIT-INDIVIDUAL
call :IE-PROXY-SETTING
call :IE-START
call :NO-IE-PROXY-SETTING

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
    set proxySrv=
    call :SELECT-CONNECT

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
REM === 接続先選択
:SELECT-CONNECT
    echo *****************************************************************
    echo menu
    echo -----------------------------------------------------------------
    echo 00:google                  https://www.google.com/
    echo 01:yahoo                   https://www.yahoo.co.jp/
    echo *****************************************************************
    set connectID=""
    set /P connectID="接続先を入力してください[Ex:00]："

    if %connectID%==00 ( 
        set connectURL=https://www.google.com/
    ) else if %connectID%==01 (
        set connectURL=https://www.yahoo.co.jp/
    ) else (
        cls
        call %commonLogBat% %cmdName% ERROR [%userID%]:選択した[%connectID%]の接続先は登録されていません
        goto SELECT-CONNECT
    )
    call %commonLogBat% %cmdName% INFO [%userID%]:[%connectURL%]に接続します
exit /b


REM ========================================
REM === Proxy設定
:IE-PROXY-SETTING
    call %commonLogBat% %cmdName% INFO [%userID%]:Proxy設定をします
    
    reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v ProxyEnable /t reg_dword /d 1
    if !errorFlag! neq 0 (
        call %commonLogBat% %cmdName% ERROR [%userID%]:Proxy設定をONにできませんでした
    ) else (
        call %commonLogBat% %cmdName% INFO [%userID%]:Proxy設定をONにしました
    )

    reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v ProxyServer /t reg_sz /d %proxySrv%
    if !errorFlag! neq 0 (
        call %commonLogBat% %cmdName% ERROR [%userID%]:Proxyサーバ[%proxySrv%]を登録できませんでした
    ) else (
        call %commonLogBat% %cmdName% INFO [%userID%]:Proxyサーバ[%proxySrv%]を登録しました
    )

    reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v ProxyOverride /t reg_sz /d "<local>"
    if !errorFlag! neq 0 (
        call %commonLogBat% %cmdName% ERROR [%userID%]:Proxy対象外設定[local]を登録できませんでした
    ) else (
        call %commonLogBat% %cmdName% INFO [%userID%]:Proxy対象外設定[local]を登録しました
    )
exit /b

REM ========================================
REM === IE?ｿｽN?ｿｽ?ｿｽ
:IE-START
    call %commonLogBat% %cmdName% INFO [%userID%]:IEを起動します
    "C:\Program Files\Internet Explorer\iexplore.exe" %connectURL%
exit /b

REM ========================================
REM === Proxy?ｿｽﾝ抵ｿｽ?ｿｽ?ｿｽ?ｿｽ
:NO-IE-PROXY-SETTING
    call %commonLogBat% %cmdName% INFO [%userID%]:Proxy設定解除します
    reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v ProxyEnable /t reg_dword /d 0
    if !errorFlag! neq 0 (
        call %commonLogBat% %cmdName% ERROR [%userID%]:Proxy設定をOFFにできませんでした
    ) else (
        call %commonLogBat% %cmdName% INFO [%userID%]:Proxy設定をOFFにしました
    )
exit /b

REM ========================================
REM === END-RTN
:END-RTN
    call %commonLogBat% %cmdName% INFO [%userID%]:IE作業終了
    echo キーを押すと終了します
    set /P input=
    set input=
    
endlocal
exit /b 0