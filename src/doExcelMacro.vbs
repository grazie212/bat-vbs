' ============================================================================
' batch-name: doExcelMacro.vbs
' about: Excel�}�N�������s���Ă����vbs
' arg0 : �N��������Excel�}�N���t�@�C��
' arg1 : Excel�}�N���t�@�C���Ŏ��s����֐�
' arg2 : Excel�}�N���t�@�C���ɓn�������p�����[�^���������ރV�[�g
' arg3 : Excel�}�N���t�@�C���ɓn�������p�����[�^
' ============================================================================

Dim excelApp : Set excelApp = CreateObject("Excel.Application")
Dim bokWork
Dim targetFile : targetFile = WScript.Arguments(0)
Dim targetMacro : targetMacro = WScript.Arguments(1)
Dim sheetsname : set sheetsname = WScript.Arguments(2)
Dim my_para : set my_para = WScript.Arguments(3)

' Excel�t�@�C�����J��
Set bokWork = excelApp.Workbooks.Open(targetFile)
bokWork.sheets(sheetsname).Cells(1, 1).Value = my_para

' �}�N���̎��s
excelApp.Run targetMacro

' Excel�̏I��
excelApp.Quit