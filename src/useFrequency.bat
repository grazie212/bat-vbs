@echo off
REM ============================================================================
REM batch-name: useFrequency.bat
REM about: �T���v���W
REM ============================================================================

REM ����̃f�B���N�g���z����ϐ��ɓ���ă��[�v
for /F "usebackq delims=" %%a in (`dir /od /b %dirname%`) do (
    echo %%a
)

REM �G���[�n���h�����O
if !errorFlag! neq 0 (
    call %commonLogBat% %cmdName% ERROR [%userID%]:�G���[���b�Z�[�W
) else (
    call %commonLogBat% %cmdName% INFO [%userID%]:���b�Z�[�W
)