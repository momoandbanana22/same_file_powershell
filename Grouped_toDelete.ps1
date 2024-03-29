# CSVファイルのパス
$csvFile = "c:\your\diretory2\filesSHA512.csv"

# CSVファイルを読み込む
$csv = Import-Csv -Path $csvFile

# 同じハッシュ値を持つファイルをグループ化する
$grouped = $csv | Group-Object -Property SHA512

# 各グループに対して処理を行う
foreach ($group in $grouped) {
  # グループ内のファイル数が1より大きい場合、それらのファイルを表示する
  if ($group.Count -gt 1) {
    Write-Output "Hash: $($group.Name)"
    Write-Output "Files:"
    # ファイルを更新日時でソート
    $sortedFiles = $group.Group | ForEach-Object { Get-Item -LiteralPath "$($_.FilePath)" } | Sort-Object LastWriteTime -Descending

    if ($group.Count -ne $sortedFiles.Count) {
      Write-Output "bug!!"
    }

    for ($i = 0; $i -lt $sortedFiles.Count; $i++) {
      # 最新のファイル以外は削除対象とする
      if ($i -ne 0) {
        Write-Output "`tDEL `"$($sortedFiles[$i].FullName)`""
        # ファイルを削除
        Remove-Item -LiteralPath $($sortedFiles[$i].FullName)
        # # CSVからそのファイルの行を削除
        # $csv = $csv | Where-Object { $_.FilePath -ne $($sortedFiles[$i].FullName) }
        # # 更新したCSVを保存
        # $csv | Export-Csv -Path $csvFile -NoTypeInformation -Encoding Unicode
      }    
    }
  }
}
