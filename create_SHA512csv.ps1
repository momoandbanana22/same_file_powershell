# SHA512を計算するファイルが格納されているディレクトリのリスト
$directories = @(
  "c:\your\directory"
)

# CSVファイルのパス
$outputFile = "c:\your\diretory2\filesSHA512.csv"

# CSVファイルが存在しない場合、ヘッダーを書き込む
if (!(Test-Path -Path $outputFile)) {
  '"SHA512","FilePath"' | Out-File -FilePath $outputFile -Encoding Unicode
}

# CSVファイルを読み込む
$csv = @(Import-Csv -Path $outputFile -Encoding Unicode)

# 各ディレクトリに対して処理を行う
foreach ($dir in $directories) {
  # ディレクトリ内のすべてのファイルを取得
  $files = Get-ChildItem -Path $dir -Recurse -File

  # 各ファイルに対して処理を行う
  foreach ($file in $files) {
    try {
      # ファイルのフルパスを取得
      $filePath = $file.FullName

      # CSV内にファイルがエントリされているか確認
      $entry = $csv | Where-Object { $_.FilePath -eq $filePath }

      # ファイルがエントリされていない、またはSHA512が記録されていない場合、SHA512を計算
      if ($null -eq $entry -or $null -eq $entry.SHA512) {
        $hash = Get-FileHash -LiteralPath $filePath -Algorithm SHA512
        $hashString = "`"$($hash.Hash)`",`"$filePath`"" 

        # CSVファイルにハッシュを追記する
        $hashString | Out-File -Append -FilePath $outputFile -Encoding Unicode
        Write-Output $hashString

        # メモリ上のCSVにも追加する
        $csv += New-Object PSObject -Property ([ordered]@{SHA512 = $hash.Hash; FilePath = $filePath })
      }
    }
    catch {
      # エラーメッセージを出力する
      Write-Output "Error processing file: $filePath"
      Write-Output $_.Exception.Message
    }
  }
}
