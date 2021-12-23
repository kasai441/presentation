# Presentation

オープンで職務経歴とスキルシートを公開するためのツールです。

## 利用方法
Ruby on Railsで起動できます。
```
rails server
```

### CSVファイルを編集する
``db/coding_record.csv``に学習時間を記入します。
必要なデータ列は以下のとおりで、その他のデータ列は使用しません。
- １列目: 開始時刻
- ２列目: 終了時刻
- ５列目: キー
```csv
2021-06-01 00:00:00, 2021-06-04 05:00:00,,,fjord,"Ruby on Rails"
```

### データベースに登録する
csvの内容をデータベースに登録するにはseedを実行します。
```
rails db:seed
```
### キーの設定をする
``app/controllers/studies_controller.rb``の`key_groups`に任意のグループを作成し、CSVで記述したキーを設定する。

![image](https://user-images.githubusercontent.com/50036730/147193273-fec35a68-96c1-4161-a6ee-ee171ee679ac.png)

次に、`names`にキーのグラフ表記名を設定する。

![image](https://user-images.githubusercontent.com/50036730/147193754-98a59059-f564-4b7f-8130-7f70d5bce2d0.png)

### スキルの円グラフ
円グラフには保有スキルの経験時間の割合と総計時間が反映されます。

![image](https://user-images.githubusercontent.com/50036730/147192210-36e46e99-dd02-438e-8ad5-bf3adc4a808f.png)

### スキルの時系列グラフ
指定期間の月毎に、各スキルの折れ線グラフと総計時間の棒グラフが表示されます。

![image](https://user-images.githubusercontent.com/50036730/147194035-f177a350-760e-4be6-93a0-c67c9b3bb5e9.png)

### Viewの直接編集
#### プロフィール
プロフィールは``app/views/studies/_summary.html.erb``を編集して作成します。

![image](https://user-images.githubusercontent.com/50036730/147194704-a84cc12e-610f-4e42-9af2-b7dead639b01.png)

#### ポートフォリオ
ポートフォリオは``app/views/studies/_portfolio.html.erb``を編集して作成します。

![image](https://user-images.githubusercontent.com/50036730/147194783-68be51b0-4837-4c37-a4c3-f3df0158fcf0.png)

#### 経歴

経歴は``app/controllers/studies_controller.rb``の`contents`を編集して作成します。

![image](https://user-images.githubusercontent.com/50036730/147194865-0c8ace0d-17ea-4f2f-b541-eae87c4a8608.png)
