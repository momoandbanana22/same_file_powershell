# same_file_powershell

powershellで作った、同一内容のファイルを探して削除するためのツールです。３つのファイル（プログラム）があります。

## `create_SHA512csv.ps1`

### 機能

* 指定されたパスにあるファイルのSHA512値を計算して、指定されたパスのCSVに結果を記録します。
* CSVファイルには追記していきます。
  * CSVファイルに存在しないファイルに対して、SHA512を計算して追記します。

### 設定方法

* 以下の箇所で、「SHA512値を計算するファイルが格納されたパス」を指定してください。カンマで区切って複数のパスを指定できます。
  ```(PowerShell)
  # SHA512を計算するファイルが格納されているディレクトリのリスト
  $directories = @(
    "c:\your\directory"
  )
  ```

* 以下の箇所で、「計算したSHA512値とパスを出力するCSVファイルのフルパス」を指定してください。
  ```(PowerShell)
  # CSVファイルのパス
  $outputFile = "c:\your\diretory2\filesSHA512.csv"
  ```

## `Grouped_toShow.ps1`

### 機能

* (上記の`create_SHA512csv.ps1`で作成したCSVファイルを入力として）同じSHA512値のファイルをグループ化して表示します。

### 設定方法

* 以下の箇所で、「(上記の`create_SHA512csv.ps1`で作成した）SHA512値とファイルパスが記録されているCSVファイル」を指定してください。
  ```(PowerShell)
  # CSVファイルのパス
  $csvFile = "c:\your\diretory2\filesSHA512.csv"
  ```

## `Grouped_toDelete.ps1`

### 機能

* (上記の`create_SHA512csv.ps1`で作成したCSVファイルを入力として）同じSHA512値のファイルのうち、更新日が最新のファイル以外を削除します。

### 設定方法

* 以下の箇所で、「(上記の`create_SHA512csv.ps1`で作成した）SHA512値とファイルパスが記録されているCSVファイル」を指定してください。
  ```(PowerShell)
  # CSVファイルのパス
  $csvFile = "c:\your\diretory2\filesSHA512.csv"
  ```
