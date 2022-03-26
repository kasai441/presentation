require './app/services/make_pie_service'
require './app/services/make_time_series_service'
require './app/services/get_chart_list_service'

class StudiesController < ApplicationController
  include ApplicationHelper

  def chart
    seq = Study.all
    key_groups = {
      other: ['unity', 'connpass', 'cobol', 'vba', 'batch', 'linux', 'git', 'asteria', 'bussiness', 'fjord'],
      design: ['css', 'prototyping'],
      db: ['sql', 'db'],
      rails: ['Progate', 'Railstutorial', 'Flashcards', 'presentation', 'rails', 'genba', 'CherryBook', 'paiza', 'atcoder', 'aizu', 'ruby'],
      js: ['nyobiko', 'JavaScript', 'vue']
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
      vue: 'Vue.js',
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

    get_chart_list_service = GetChartListService.new(seq, key_groups, start_day, names)
    chart_list = get_chart_list_service.get_chart

    chart_title = '時系列 推移'
    make_time_series_service = MakeTimeSeriesService.new(chart_title, chart_list)
    @chart0 = make_time_series_service.make_series

    t = []
    chart_list.each_value {|e| t << e[:total].to_i}
    @subject_times = t

    make_pie_service = MakePieService.new(chart_list)
    @chart1 = make_pie_service.make_pie

    @jobs = []
    titles = [:start, :duration, :subject, :task, :skill, :category, :team]
    contents = []
    contents << ["2021/1","15","【スクール】\nフィヨルドブートキャンプ","・Linux/Git\n・Ruby on Rails\n・JavaScript/Vue.js\n・Railsアプリ「Bootcamp」スクラム\n・自作Railsアプリ「Ruumarker」","【OS, Tool】 MacOS, Linux Debian, bash, zsh, Vi, Git/GitHub\n 【インフラ】 HTTP, Nginx, AWS S3, Heroku, GitHub Action\n 【DB】 Postgresql, Sqlite3, LocalStrage\n 【バックエンド】 Ruby, Sinatra, Ruby on Rails, Node.js\n 【フロントエンド】 JavaScript, Vue.js, Webpack, Babel, HTML/CSS\n 【テスト】 Minitest, Rspec, Jest","設計\n製造\nテスト\n保守","アジャイル"]
    contents << ["2020/9","04","金融システム\nリプレース（VB.net→Java）","・Javaバッチ\n・Linux Shell\n・Windowsバッチファイル\n・Webアプリ","【OS, Tool】 Linux, Windows, csh, batch file, Eclipse, SVN\n 【DB】 Oracle\n 【バックエンド】 VB.net, Java, Spring Boot, Node.js\n 【フロントエンド】 JavaScript, JQuery, Webpack, CSS\n 【テスト】 JUnit, 手動テスト","設計\n製造\nテスト","ウォーターフォール\n5人体制\nメンバー"]
    contents << ["2020/7","02","金融システム\nバッチファイル開発","・Windowsバッチファイル\n・SQLプロシージャ","【OS, Tool】Windows, batch file, サクラエディタ\n 【DB】T-SQL/SQL Server\n【テスト】手動テスト","製造\nテスト","ウォーターフォール\n4人体制\nメンバー"]
    contents << ["2019/10","09","【自習】\nRails Tutorial\n自作アプリ開発","・Rails Tutorial\n・Ruby\n・自作Railsアプリ「Flashcards」\n・自作Railsアプリ「WEBスキルシート」\n・N予備校 Node.js学習","【OS, Tool】 Linux Ubuntu, MacOS, Windows, bash, Vi, Git/GitHub\n 【インフラ】VirtualBox, Vagrant, AWS Cloud9, Heroku\n 【DB】 Sqlite3\n 【バックエンド】Ruby, Ruby on Rails, Node.js\n 【フロントエンド】 HTML/CSS\n 【テスト】 Minitest","設計\n製造\nテスト","-"]
    contents << ["2018/10","12","電子カルテシステム\n保守","・顧客対応\n・データベースリカバリ\n・アップデートテスト","【OS, Tool】 Windows, サクラエディタ\n 【DB】T-SQL/SQL Server\n 【Script】C#, VBA\n【テスト】手動テスト","保守\nテスト","ウォーターフォール\n2-5人体制\nメンバー"]
    contents << ["2018/7","03","ECサイト\nバッチ開発","・ASTERIA Warp, JP1バッチ\n・SQLプロシージャ","【OS, Tool】Windows, ASTERIA Warp, JP1, 秀丸\n 【DB】T-SQL/SQL Server\n 【Script】WSH\n【テスト】手動テスト","製造\nテスト","ウォーターフォール\n6人体制\nメンバー"]
    contents << ["2018/2","06","【研修】\nWEBアプリ開発","・Java WEBアプリ\n・Android","【OS, Tool】 Linux, bash, Xampp, Android Studio, Eclipse, Git/GitHub\n 【インフラ】Apache Tomcat\n 【DB】 MariaDB\n 【バックエンド】Java, servlet/JSP, PHP\n 【フロントエンド】JavaScript, HTML/CSS","設計\n製造","ウォーターフォール"]
    # contents << ["2015/10","29","2DCG制作","2DCGゲーム背景作成","Photoshop","","体制人数：1人"]
    # contents << ["2007/4","27","建築設計／都市デザイン","・建築設計、土木設計\n・CADを使った作図\n・グラフ、統計資料など各種ドキュメント作成","","",""]
    # contents << ["2004/5","28","経営管理事務","・経営計画立案\n・株式上場に向けたアクション\n・議事録など各種ドキュメント作成","","","体制人数：4人\n役職：部長"]
    contents.size.times do |i|
      job = {}
      titles.each_with_index do |title, j|
        job[title] = hbr(contents[i][j])
      end
      @jobs << job
    end

    @summary = []
    titles = [:age, :sex, :work_months, :qualification]
    dob = Time.zone.parse('1981-07-10')
    now = Time.zone.now.to_date
    age = now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    work_months = chart_list[:other][:dates].size

    contents = []
    contents << [age.to_s,"男","#{work_months}ヶ月","基本情報技術者\nOracle Java Silver SE 8\nTOEIC 840点"]
    contents.size.times do |i|
      summary = {}
      titles.each_with_index do |title, j|
        summary[title] = hbr(contents[i][j])
      end
      @summary << summary
    end
  end
end
