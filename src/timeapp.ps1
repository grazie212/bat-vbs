# .NET Framework クラスを読み込み
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function startForm {
    param (
        [Datetime]$Date = (Get-Date) #現在日時を初期値に設定
    )
    
    # フォーム クラスの定義
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Select job'
    $form.Size = New-Object System.Drawing.Size(300,250)
    $form.StartPosition = 'CenterScreen'

    #  [OK] ボタンを作成
    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(75,180)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = 'OK'
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    # [キャンセル] ボタンを作成
    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(150,180)
    $CancelButton.Size = New-Object System.Drawing.Size(75,23)
    $CancelButton.Text = 'Cancel'
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    # ラベルのテキストをウィンドウ上に用意
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = 'Please select a job:'
    $form.Controls.Add($label)

    # ラベルのテキストに記述した情報をユーザーに提供するコントロールを追加
    $listBox = New-Object System.Windows.Forms.ListBox
    $listBox.Location = New-Object System.Drawing.Point(10,40)
    $listBox.Size = New-Object System.Drawing.Size(260,20)
    $listBox.Height = 80

    $listContent = @("会議","設計","検証","構築","テスト","運用","雑務")
    foreach ($lc in $listContent){
        [void] $listBox.Items.Add($lc)
    }
    # フォームを開くときに他のウィンドウとダイアログボックスの最上部に開くよう、Windowsに指示
    $form.Controls.Add($listBox)

    # ラベルのテキストをウィンドウ上に用意
    $textBoxLabel = New-Object System.Windows.Forms.Label
    $textBoxLabel.Location = New-Object System.Drawing.Point(10,120)
    $textBoxLabel.Size = New-Object System.Drawing.Size(280,20)
    $textBoxLabel.Text = 'Memo:'
    $form.Controls.Add($textBoxLabel)
    
    # 作業メモ入力ボックスの設定
    $textBox = New-Object System.Windows.Forms.TextBox 
    $textBox.Location = New-Object System.Drawing.Point(10,140) 
    $textBox.Size = New-Object System.Drawing.Size(260,10)
    $form.Controls.Add($textBox) 

    $form.Topmost = $true

    # Windows でフォームを表示
    $result = $form.ShowDialog()
    # 入力結果を代入
    [string[]]$rtnArr = @("None","None")
    if ($result -eq [System.Windows.Forms.DialogResult]::OK){
        $listitem = $listBox.SelectedItem
        $rtnArr[0] = $listitem
        $rtnArr[1] = $textBox.Text
        return $rtnArr
    } else {
        return $rtnArr
    }
}

function stopForm([string]$args1, [array]$args2) {
    $startCode = $args1 + " " + $args2[0] + " " + $args2[1]

    # フォーム クラスの定義
    $endform = New-Object System.Windows.Forms.Form
    $endform.Text = 'Select a Computer'
    $endform.Size = New-Object System.Drawing.Size(300,200)
    $endform.StartPosition = 'CenterScreen'


    # ラベルのテキストをウィンドウ上に用意
    $endlabel = New-Object System.Windows.Forms.Label
    $endlabel.Location = New-Object System.Drawing.Point(10,20)
    $endlabel.Size = New-Object System.Drawing.Size(280,20)
    $endlabel.Text = $startCode
    $endform.Controls.Add($endlabel)

    #  [終了] ボタンを作成
    $ENDButton = New-Object System.Windows.Forms.Button
    $ENDButton.Location = New-Object System.Drawing.Point(75,120)
    $ENDButton.Size = New-Object System.Drawing.Size(75,23)
    $ENDButton.Text = '完了'
    $ENDButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $endform.AcceptButton = $ENDButton
    $endform.Controls.Add($ENDButton)

    #  [帰宅] ボタンを作成
    $KITAKUButton = New-Object System.Windows.Forms.Button
    $KITAKUButton.Location = New-Object System.Drawing.Point(150,120)
    $KITAKUButton.Size = New-Object System.Drawing.Size(75,23)
    $KITAKUButton.Text = '帰宅'
    $KITAKUButton.DialogResult = [System.Windows.Forms.DialogResult]::Abort 
    $endform.AcceptButton = $KITAKUButton
    $endform.Controls.Add($KITAKUButton)

    # フォームを開くときに他のウィンドウとダイアログ ボックスの最上部に開くよう、Windows に指示
    $endform.Topmost = $true

    # Windows でフォームを表示
    $endresult = $endform.ShowDialog()
    if ($endresult -eq [System.Windows.Forms.DialogResult]::OK){
        return 0
    } else {
        return 99
    }
}

# メイン処理
$formatted_date = (Get-Date).ToString("yyyyMM")
[string]$filename = "D:\${formatted_date}_作業実績.csv"

while ($true) {
    $jobArr = startForm
    $startDate = Get-Date

    $rc = stopForm $startDate $jobArr
    $endDate = Get-Date

    # 差分確認
    $timeDiff = $endDate - $startDate
    $timeDiffString = [string]$timeDiff
    $timeDiffSplit = $timeDiffString.Split(".")

    # ファイル出力
    $printText = [string]$startDate + "," + [string]$endDate + "," + $jobArr[0] + "," + $timeDiffSplit[0] + "," + $jobArr[1]
    Write-Output $printText | Add-Content $filename -Encoding String

    if ($rc -eq 99) {
        break
    }
}

