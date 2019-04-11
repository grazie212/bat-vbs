@echo off
REM ============================================================================
REM batch-name: useFrequency.bat
REM about: サンプル集
REM ============================================================================

REM 特定のディレクトリ配下を変数に入れてループ
for /F "usebackq delims=" %%a in (`dir /od /b %dirname%`) do (
    echo %%a
)

REM エラーハンドリング
if !errorFlag! neq 0 (
    call %commonLogBat% %cmdName% ERROR [%userID%]:エラーメッセージ
) else (
    call %commonLogBat% %cmdName% INFO [%userID%]:メッセージ
)