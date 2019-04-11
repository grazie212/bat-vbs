' ============================================================================
' batch-name: doExcelMacro.vbs
' about: Excelマクロを実行してくれるvbs
' arg0 : 起動したいExcelマクロファイル
' arg1 : Excelマクロファイルで実行する関数
' arg2 : Excelマクロファイルに渡したいパラメータを書き込むシート
' arg3 : Excelマクロファイルに渡したいパラメータ
' ============================================================================

Dim excelApp : Set excelApp = CreateObject("Excel.Application")
Dim bokWork
Dim targetFile : targetFile = WScript.Arguments(0)
Dim targetMacro : targetMacro = WScript.Arguments(1)
Dim sheetsname : set sheetsname = WScript.Arguments(2)
Dim my_para : set my_para = WScript.Arguments(3)

' Excelファイルを開く
Set bokWork = excelApp.Workbooks.Open(targetFile)
bokWork.sheets(sheetsname).Cells(1, 1).Value = my_para

' マクロの実行
excelApp.Run targetMacro

' Excelの終了
excelApp.Quit