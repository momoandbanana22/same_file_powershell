# CSVファイルのパス
$csvFile = "H:\filesSHA512.csv"

# CSVファイルを読み込む
$csv = Import-Csv -Path $csvFile

# グループ化処理の開始時間を表示
Write-Output "Start time: $(Get-Date)"

# 同じハッシュ値を持つファイルをグループ化する
$grouped = $csv | Group-Object -Property SHA512

# グループ化処理の終了時間を表示
Write-Output "End time: $(Get-Date)"

# 各グループに対して処理を行う
foreach ($group in $grouped) {
  # グループ内のファイル数が1より大きい場合、それらのファイルを表示する
  if ($group.Count -gt 1) {
    Write-Output "Hash: $($group.Name)"
    Write-Output "Files:"
    foreach ($file in $group.Group) {
      Write-Output "`t$($file.FilePath)"
    }
  }
}
