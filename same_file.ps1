# 検索対象ディレクトリ
$TargetDirectorys = @(
  "D:\Download\a",
  "D:\Download\b",
  "D:\Download\c"
)

# 結果を格納するハッシュテーブルの初期化(空のハッシュテーブルを作成)
$results = @{}

# 複数の検索対象ディレクトリからファイル一覧を取得
$targetitems = @()
$TargetDirectorys | ForEach-Object {
  $targetitems += (Get-ChildItem $_ -File -Recurse)
}

# ファイル一覧から重複を検索
$targetitems | ForEach-Object {
  $FileSize = $_.Length
  if ($results.ContainsKey($FileSize)) { # このファイルサイズは登録されている？
    # ファイルサイズあり
    if ($results[$FileSize].Count -eq 1) { # ファイルハッシュの登録が１件？
      foreach($FileHashEntry in $results[$FileSize].GetEnumerator()){ # １件しかないんだけど取り出し方がわかんないので、ループを回してキーを取り出す
        $key = $FileHashEntry.Key;
      }
      if ($key -eq "") { # １件しかないハッシュは空文字か？
        # ファイルは１つしかない＝２つ目を登録しようとしている＝その２つのハッシュを比較する必要がある＝１つ目のハッシュを計算する
        $FileItem = $results[$FileSize][$key][0]
        $FileHash = ($FileItem | Get-FileHash -Algorithm SHA512)
        $FileArrays = (New-Object System.Collections.ArrayList)
        $null = $FileArrays.Add($FileItem)
        
        $FileHashes = @{} # 空のハッシュテーブル
        $FileHashes.add($FileHash.Hash, $FileArrays) # 配列と紐づいたファイルハッシュを登録
        
        $null = $results.Remove($FileSize) # ファイルサイズと紐づいたファイルハッシュを削除
        $null = $results.Add($FileSize , $FileHashes) # ファイルサイズと紐づいたファイルハッシュを登録
      }
    }
    # ファイルハッシュ計算済み１件（上のifを通った） or ファイルハッシュ計算済み複数件
    $FileHash = ($_ | Get-FileHash -Algorithm SHA512)
    if (! $results[$FileSize].ContainsKey($FileHash.Hash)) { # このファイルハッシュは登録されている？
      # ファイルハッシュ未登録
      $FileArrays = (New-Object System.Collections.ArrayList) # 空の配列
      $null = $FileArrays.Add($_) # 配列にファイルを追加＝ファイル１つだけの配列
      $null = $results[$FileSize].Add($FileHash.Hash, $FileArrays) # 配列と紐づいたファイルハッシュを登録
    }else{
      # ファイルハッシュ登録済み
      $null = $results[$FileSize][$FileHash.Hash].Add($_) # そのファイルハッシュに紐づいた配列にファイルを追加
    }
  }else{
    # ファイルサイズなし→ファイルハッシュ未計算（空文字）で、ファイルを登録
    $FileArrays = (New-Object System.Collections.ArrayList) # 空の配列
    $null = $FileArrays.Add($_) # 配列にファイルを追加＝ファイル１つだけの配列
    $FileHashes = @{} # 空のハッシュテーブル
    $null = $FileHashes.add("",$FileArrays) # 配列と紐づいたファイルハッシュ(ただし未計算の""）を登録
    $null = $results.Add($FileSize , $FileHashes) # ファイルサイズと紐づいたファイルハッシュを登録
  }
}

# ファイルサイズ順（大きい順）にソート
$results = $results.GetEnumerator() | Sort-Object -Property key

# 同じ内容（同じハッシュ値）のファイルの組み合わせを表示
foreach($OneSizeEntry in $results.GetEnumerator()){
  foreach($OneHashEntry in $OneSizeEntry.Value.GetEnumerator()) {
    $files = $OneHashEntry.Value
    if ($files.Count -gt 1) {
      $hash = $OneHashEntry.Key
      $filesize = $files[0].Length
      Write-Output "rem =${hash}= filesize = ${filesize}"
      foreach($OneFileEntry in $files.GetEnumerator()){
        # $path = 'rem rmdir /s /q "' + $OneFileEntry.FullName + '"'
        $path = 'rem del "' + $OneFileEntry.FullName + '"'
        Write-Output "${path}"
      }
      Write-Output "rem --------"
    }
  }
}
