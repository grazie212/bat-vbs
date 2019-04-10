@echo off
REM ============================================================================
REM batch-name: proxy_ie.bat
REM about: IE�̃v���L�V�ݒ肵�Ă����o�b�`
REM ============================================================================
setlocal ENABLEDELAYEDEXPANSION
cd /d %~dp0

REM ========================================
REM === ���C���V�[�P���X
call :INIT
call :INIT-INDIVIDUAL
call :IE-PROXY-SETTING
call :IE-START
call :NO-IE-PROXY-SETTING

goto END-RTN
REM === ���C���V�[�P���XEND
REM ========================================


REM ========================================
REM === �o�b�`�̕K�{�ϐ�
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
REM === �o�b�`�̌ʕϐ�
:INIT-INDIVIDUAL
    call :USERID-SELECT
    REM proxyServer�����
    set proxySrv=
    call :SELECT-CONNECT

exit /b

REM ========================================
REM === ���[�UID�I��
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
    set /P userIDselect="���[�UID����͂��Ă�������[Ex:01]�F"
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
        call %commonLogBat% %cmdName% ERROR �I������[%userIDselect%]�̃��[�U�͓o�^����Ă��܂���
        goto USERID-SELECT
    )
    cls
exit /b

REM ========================================
REM === �ڑ���I��
:SELECT-CONNECT
    echo *****************************************************************
    echo menu
    echo -----------------------------------------------------------------
    echo 00:google                  https://www.google.com/
    echo 01:yahoo                   https://www.yahoo.co.jp/
    echo *****************************************************************
    set connectID=""
    set /P connectID="�ڑ������͂��Ă�������[Ex:00]�F"

    if %connectID%==00 ( 
        set connectURL=https://www.google.com/
    ) else if %connectID%==01 (
        set connectURL=https://www.yahoo.co.jp/
    ) else (
        cls
        call %commonLogBat% %cmdName% ERROR [%userID%]:�I������[%connectID%]�̐ڑ���͓o�^����Ă��܂���
        goto SELECT-CONNECT
    )
    call %commonLogBat% %cmdName% INFO [%userID%]:[%connectURL%]�ɐڑ����܂�
exit /b


REM ========================================
REM === Proxy�ݒ�
:IE-PROXY-SETTING
    call %commonLogBat% %cmdName% INFO [%userID%]:Proxy�ݒ�����܂�
    
    reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v ProxyEnable /t reg_dword /d 1
    if !errorFlag! neq 0 (
        call %commonLogBat% %cmdName% ERROR [%userID%]:Proxy�ݒ��ON�ɂł��܂���ł���
    ) else (
        call %commonLogBat% %cmdName% INFO [%userID%]:Proxy�ݒ��ON�ɂ��܂���
    )

    reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v ProxyServer /t reg_sz /d %proxySrv%
    if !errorFlag! neq 0 (
        call %commonLogBat% %cmdName% ERROR [%userID%]:Proxy�T�[�o[%proxySrv%]��o�^�ł��܂���ł���
    ) else (
        call %commonLogBat% %cmdName% INFO [%userID%]:Proxy�T�[�o[%proxySrv%]��o�^���܂���
    )

    reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v ProxyOverride /t reg_sz /d "<local>"
    if !errorFlag! neq 0 (
        call %commonLogBat% %cmdName% ERROR [%userID%]:Proxy�ΏۊO�ݒ�[local]��o�^�ł��܂���ł���
    ) else (
        call %commonLogBat% %cmdName% INFO [%userID%]:Proxy�ΏۊO�ݒ�[local]��o�^���܂���
    )
exit /b

REM ========================================
REM === IE�N��
:IE-START
    call %commonLogBat% %cmdName% INFO [%userID%]:IE���N�����܂�
    "C:\Program Files\Internet Explorer\iexplore.exe" %connectURL%
exit /b

REM ========================================
REM === Proxy�ݒ����
:NO-IE-PROXY-SETTING
    call %commonLogBat% %cmdName% INFO [%userID%]:Proxy�ݒ�������܂�
    reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v ProxyEnable /t reg_dword /d 0
    if !errorFlag! neq 0 (
        call %commonLogBat% %cmdName% ERROR [%userID%]:Proxy�ݒ��OFF�ɂł��܂���ł���
    ) else (
        call %commonLogBat% %cmdName% INFO [%userID%]:Proxy�ݒ��OFF�ɂ��܂���
    )
exit /b

REM ========================================
REM === END-RTN
:END-RTN
    call %commonLogBat% %cmdName% INFO [%userID%]:IE��ƏI��
    echo �L�[�������ƏI�����܂�
    set /P input=
    set input=
    
endlocal
exit /b 0