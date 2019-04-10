@echo off
REM ============================================================================
REM batch-name: common_log.bat
REM about: 共通ログ出力バッチ
REM %1: 呼び出し元ファイル
REM %2: ログ出力コード
REM %3: ログ出力メッセージ
REM ============================================================================
setlocal
cd /d %~dp0

REM ========================================
REM === メインシーケンス
call :INIT
call :INIT-INDIVIDUAL %1 %2 %3
call :LOG-OUT-INDIVIDUAL 
call :LOG-OUT-COMMON

goto END-RTN
REM === メインシーケンスEND
REM ========================================

REM ========================================
REM === バッチの必須変数
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
REM === バッチの個別変数
:INIT-INDIVIDUAL
    set nowTime=%Date% %Time%
    set callerCmdName=%1
    set logCode=%2
    set logMessage=%3
exit /b

REM ========================================
REM === 個別ログファイル書き込み
:LOG-OUT-INDIVIDUAL
    set DspMsg=%Date% %Time% [%callerCmdName%] %logCode%:%logMessage%
    echo %DspMsg% >> %logDir%\%callerCmdName%_%hostname%_%dateStamp%.log
    echo %DspMsg% 
exit /b

REM ========================================
REM === 共通ログファイル書き込み
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