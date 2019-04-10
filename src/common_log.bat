@echo off
REM ============================================================================
REM batch-name: common_log.bat
REM about: ���ʃ��O�o�̓o�b�`
REM %1: �Ăяo�����t�@�C��
REM %2: ���O�o�̓R�[�h
REM %3: ���O�o�̓��b�Z�[�W
REM ============================================================================
setlocal
cd /d %~dp0

REM ========================================
REM === ���C���V�[�P���X
call :INIT
call :INIT-INDIVIDUAL %1 %2 %3
call :LOG-OUT-INDIVIDUAL 
call :LOG-OUT-COMMON

goto END-RTN
REM === ���C���V�[�P���XEND
REM ========================================

REM ========================================
REM === �o�b�`�̕K�{�ϐ�
:INIT
    set cmdName=%~n0
    set dateStamp=%date:/=%
    set hostname=%COMPUTERNAME%
    set errorFlag=0
    set logName=%cmdName%_%hostname%_%dateStamp%.log
    set creDir=%~dp0
    set logDir=%creDir%logs
    
exit /b

REM ========================================
REM === �o�b�`�̌ʕϐ�
:INIT-INDIVIDUAL
    set nowTime=%Date% %Time%
    set callerCmdName=%1
    set logCode=%2
    set logMessage=%3
exit /b

REM ========================================
REM === �ʃ��O�t�@�C����������
:LOG-OUT-INDIVIDUAL
    set DspMsg=%Date% %Time% [%callerCmdName%] %logCode%:%logMessage%
    echo %DspMsg% >> %logDir%\%callerCmdName%_%hostname%_%dateStamp%.log
    echo %DspMsg% 
exit /b

REM ========================================
REM === ���ʃ��O�t�@�C����������
:LOG-OUT-COMMON
    set DspMsg=%Date% %Time% [%callerCmdName%] %logCode%:%logMessage%
    echo %DspMsg% >> %logDir%\COMMON_%hostname%_%dateStamp%.log
exit /b

REM ========================================
REM === END-RTN
:END-RTN
    REM 
exit /b 0
endlocal