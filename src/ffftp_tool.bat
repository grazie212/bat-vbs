@echo off
REM ============================================================================
REM batch-name: ffftp_tool.bat
REM about: FFFTP��֗��Ɏg���o�b�`
REM ============================================================================
setlocal
cd /d %~dp0

REM ========================================
REM === ���C���V�[�P���X
call :INIT
call :INIT-INDIVIDUAL

REM ffftp�N��
call %commonLogBat% %cmdName% INFO [%userID%]:FFFTP��ƊJ�n
call "C:\product\ffftp\FFFTP.exe" -n "%initFile%"

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
    set initFile=%creDir%\config\FFFTP.ini
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
REM === END-RTN
:END-RTN
    call %commonLogBat% %cmdName% INFO [%userID%]:FFFTP��ƏI��
    echo �L�[�������ƏI�����܂�
    set /P input=
    set input=
    
endlocal
exit /b 0