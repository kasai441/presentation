# frozen_string_literal: true

# require './app/services/make_pie_service'
# require './app/services/make_time_series_service'
# require './app/services/get_chart_list_service'

class StudiesController < ApplicationController
  include ApplicationHelper

  def chart
    seq = Study.all
    key_groups = {
      other: %w[unity connpass cobol vba batch linux git asteria business fjord],
      design: %w[css prototyping],
      db: %w[sql db],
      rails: %w[Progate Railstutorial Flashcards presentation rails genba CherryBook paiza
                atcoder aizu ruby],
      js: %w[nyobiko JavaScript vue]
    }
    # データ開始日
    start_day = '2018-02-01'
    # 各項目のグラフ表記名
    names = {
      total: '総計',
      other: 'その他',
      ruby: 'Ruby',
      rails: 'Ruby on Rails',
      db: 'データベース',
      js: 'JavaScript',
      design: 'デザイン',
      'java': 'Java',
      'sql': 'SQL',
      'asteria': 'ASTERIA Warp/JP1',
      'hospital-system': '電子カルテ保守',
      'Progate': 'Progate 各種講座',
      'Railstutorial': 'Rails Tutorial',
      'CherryBook': 'Ruby入門書（プロを目指す人のためのRuby入門）',
      'Flashcards': '自作アプリ開発「Flashcards」',
      'presentation': 'ポートフォリオ開発（自作）',
      'paiza': 'paizaアルゴリズムテスト',
      'atcoder': 'atcoderアルゴリズムテスト',
      'aizu': 'AIZU ONLINE JUDGE アルゴリズムテスト',
      'unity': 'unity',
      'nyobiko': 'N予備校 nodejs講座',
      'connpass': 'connpass 勉強会',
      'cobol': 'cobol',
      'vba': 'vba',
      'batch': 'バッチプログラム開発',
      'JavaScript': 'JavaScript',
      'fjord': 'フィヨルドブートキャンプ',
      'vue': 'Vue.js',
      'genba': '現場Rails輪読会'
    }
    #
    # get_chart_list_service = GetChartListService.new(seq, key_groups, start_day, names)
    # chart_list = get_chart_list_service.get_chart
    #
    # chart_title = '時系列 推移'
    # make_time_series_service = MakeTimeSeriesService.new(chart_title, chart_list)
    # @chart0 = make_time_series_service.make_series
    #
    # t = []
    # chart_list.each_value { |e| t << e[:total].to_i }
    # @subject_times = t
    #
    # make_pie_service = MakePieService.new(chart_list)
    # @chart1 = make_pie_service.make_pie

    @jobs = []
    titles = %i[start duration subject task skill category team]
    contents = []
    contents << ['2021/1', '15', "【スクール】\nフィヨルドブートキャンプ",
                 "●Linux/Git\n●Ruby on Rails\n●JavaScript/Vue.js\n●Railsアプリ「Bootcamp」スクラム\n●自作Railsアプリ「Ruumarker」",
                 "【OS, Tool】MacOS, Linux Debian, bash, zsh, Vi, Git/GitHub\n【インフラ】HTTP, Nginx, AWS S3, Heroku, GitHub Action\n【DB】Postgresql, Sqlite3, LocalStrage\n【バックエンド】Sinatra, Ruby on Rails, Node.js\n【フロントエンド】JavaScript, Vue.js, Webpack, Babel, HTML/CSS\n【テスト】Minitest, Rspec, Jest",
                 "設計\n製造\nテスト\n保守", 'アジャイル']
    contents << ['2020/9', '04', "金融システム\nリプレース（VB.net→Java）",
                 "●Javaバッチ\n●Linux Shell\n●Windowsバッチファイル\n●Webアプリ",
                 "【OS, Tool】Linux, Windows, csh, batch file, Eclipse, SVN\n【DB】Oracle\n【バックエンド】VB.net, Java, Spring Boot, Node.js\n【フロントエンド】JavaScript, JQuery, Webpack, CSS\n【テスト】JUnit, 手動テスト",
                 "設計\n製造\nテスト", "ウォーターフォール\n5人体制\nメンバー"]
    contents << ['2020/7', '02', "金融システム\nバッチファイル開発",
                 "●Windowsバッチファイル\n●SQLプロシージャ",
                 "【OS, Tool】Windows, batch file, サクラエディタ\n【DB】T-SQL/SQL Server\n【テスト】手動テスト",
                 "製造\nテスト", "ウォーターフォール\n4人体制\nメンバー"]
    contents << ['2019/10', '09', "【自習】\nRails Tutorial\n自作アプリ開発",
                 "●Rails Tutorial\n●Ruby\n●自作Railsアプリ「Flashcards」\n●自作Railsアプリ「WEBスキルシート」\n●N予備校 Node.js学習",
                 "【OS, Tool】Linux Ubuntu, MacOS, Windows, bash, Vi, Git/GitHub\n【インフラ】VirtualBox, Vagrant, AWS Cloud9, Heroku\n【DB】Sqlite3\n【バックエンド】Ruby on Rails, Node.js\n【フロントエンド】HTML/CSS\n【テスト】Minitest",
                 "設計\n製造\nテスト", '-']
    contents << ['2018/10', '12', "電子カルテシステム\n保守",
                 "●顧客対応\n●データベースリカバリ\n●アップデートテスト",
                 "【OS, Tool】Windows, サクラエディタ\n【DB】T-SQL/SQL Server\n【Script】C#, VBA\n【テスト】手動テスト",
                 "保守\nテスト", "ウォーターフォール\n2〜5人体制\nメンバー"]
    contents << ['2018/7', '03', "ECサイト\nバッチ開発",
                 "●ASTERIA Warp, JP1バッチ\n●SQLプロシージャ",
                 "【OS, Tool】Windows, ASTERIA Warp, JP1, 秀丸\n【DB】T-SQL/SQL Server\n【Script】WSH\n【テスト】手動テスト",
                 "製造\nテスト", "ウォーターフォール\n6人体制\nメンバー"]
    contents << ['2018/2', '05', "【研修】\nWEBアプリ開発",
                 "●Java WEBアプリ\n●Android",
                 "【OS, Tool】Linux, bash, Xampp, Android Studio, Eclipse, Git/GitHub\n【インフラ】Apache Tomcat\n【DB】MariaDB\n【バックエンド】Java, servlet/JSP, PHP\n【フロントエンド】JavaScript, HTML/CSS",
                 "設計\n製造", 'ウォーターフォール']
    contents.size.times do |i|
      job = {}
      titles.each_with_index do |title, j|
        job[title] = hbr(contents[i][j])
      end
      @jobs << job
    end

    @ex_jobs = []
    contents = []
    contents << ['2015/10', '29', 'イラスト制作',
                 "●スマホゲーム背景\n●PCゲーム背景\n●約15タイトル　約100件",
                 '【イラスト】Photoshop', '業務委託', '1人体制']
    contents << ['2009/8', '74', "【自主制作】\nイラスト●漫画",
                 "●SNS投稿\n●同人誌即売会頒布\n●ポートフォリオ作成\n●コンペ投稿",
                 '【イラスト】Photoshop', '', '']
    contents << ['2008/12', '07', '土木設計',
                 "●ダム設計資料作成\n●雑務",
                 "【ドキュメント】Word, Excel\n【CAD】AutoCAD", 'アルバイト', "約10人体制\nメンバー"]
    contents << ['2007/8', '09', '建築設計／都市デザイン',
                 "●住宅意匠設計\n●都市計画説明会\n●模型作成",
                 '【CAD】Vectorworks', 'アルバイト', "5人体制\nメンバー"]
    contents << ['2007/4', '12', "【スクール】\n建築設計／都市デザイン",
                 "●意匠設計, 構造設計, 設備設計\n●文化祭実行委員",
                 "【ソフトスキル】リーダーシップ\n【デザイン】デッサン, 写真", '', '']
    contents << ['2005/4', '17', 'ファイナンス事務',
                 "●経営計画, 会計資料\n●株式上場事務（2005/12に上場）, IR, 株主総会\n",
                 "【ドキュメント】Word, Excel\n【ソフトスキル】リーダーシップ\n", '正社員', "4〜5人体制\nチームリーダー"]
    contents << ['2004/5', '11', 'ファイナンス事務',
                 "●経営計画, 会計資料\n●株式上場事務（2004/12に上場）, IR, 株主総会\n",
                 '【ドキュメント】Word, Excel', 'アルバイト', "3〜4人体制\nメンバー"]
    contents << ['2001/4', '24', '塾講師',
                 "●小学生, 中学生, 高校生\n●個別授業, 教室授業",
                 '【ソフトスキル】リーダーシップ, プレゼンテーション', 'アルバイト', "1〜2人体制\nメンバー"]
    contents.size.times do |i|
      job = {}
      titles.each_with_index do |title, j|
        job[title] = hbr(contents[i][j])
      end
      @ex_jobs << job
    end

    @summary = []
    titles = %i[age sex work_months qualification]
    dob = Time.zone.parse('1981-07-10')
    now = Time.zone.now.to_date
    age = now.year - dob.year - (now.month > dob.month || (now.month == dob.month && now.day >= dob.day) ? 0 : 1)
    # work_months = chart_list[:other][:dates].size
    work_months = 0

    contents = []
    contents << [age.to_s, '男', "#{work_months}ヶ月", "基本情報技術者\nOracle Java Silver SE 8\nTOEIC 840点"]
    contents.size.times do |i|
      summary = {}
      titles.each_with_index do |title, j|
        summary[title] = hbr(contents[i][j])
      end
      @summary << summary
    end
  end
end
