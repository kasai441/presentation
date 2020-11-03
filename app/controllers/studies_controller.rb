# require './app/services/make_pie_service'
# require './app/services/make_time_series_service'
# require_relative '../services/get_chart_list_service'
require 'make_pie_service'
require 'make_time_series_service'
require 'get_chart_list_service'

class StudiesController < ApplicationController
  include ApplicationHelper

  def chart
    seq = Study.all
    # その他に含める項目
    key_groups = {
      other: ['unity', 'connpass', 'cobol', 'vba', 'batch'],
      ruby: ['Progate', 'Railstutorial', 'CherryBook', 'Flashcards', 'presentation', 'paiza', 'atcoder', 'aizu'],
      js: ['nyobiko', 'JavaScript'],
    }
    # データ開始日
    start_day = '2018-02-01'
    # 各項目のグラフ表記名
    names = { 
      total: '総計',
      other: 'その他',
      ruby: 'Ruby on Rails',
      js: 'JavaScript',
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
      'JavaScript': 'JavaScript' 
    }

    get_chart_list_service = GetChartListService.new(seq, key_groups, start_day, names)
    chart_list = get_chart_list_service.get_chart
    # debugger

    chart_title = '時系列 推移'
    make_time_series_service = MakeTimeSeriesService.new(chart_title, chart_list)
    @chart0 = make_time_series_service.make_series

    t = []
    chart_list.each_value {|e| t << e[:total].to_i}
    @subject_times = t

    make_pie_service = MakePieService.new(chart_list)
    @chart1 = make_pie_service.make_pie

    @jobs = []
    titles = [:dates, :subject, :task, :language, :category, :team]
    contents = []
    contents << ["2020/9\n-\n2020/12\n\n4ヶ月","金融システムリプレース（VB.net→Java）\nバッチ開発\nユーザー画面開発","・Javaバッチファイル\n・Linux shell開発\n・Webアプリ画面開発","Java\nJUNIT\nVB.net\nShell Script\nSpring Boot\nMyBatis\nThymeleaf\nnodejs\nJavaScript\nJQUERY\nOracle DB\nSVN","設計\n製造\nテスト",""]
    contents << ["2020/7\n-\n2020/8\n\n2ヶ月","金融システムバッチ開発","・バッチ開発\n・SQLプロシージャ","バッチ\nSQL Server","製造\nテスト",""]
    contents << ["2019/10\n-\n2020/6\n\n9ヶ月","自習","・Rails Tutorial\n・Ruby入門書（プロを目指す人のためのRuby入門）\n・自作アプリ開発「Flashcards」\n・WEBスキルシート \n・N予備校 nodejs ","Ruby on Rails\nJavaScript\nnodejs\nVirtualBox\nGit","設計\n製造\nテスト",""]
    contents << ["2018/10\n-\n2019/9\n\n12ヶ月","電子カルテシステム保守","・顧客対応\n・データベースリカバリ\n・アップデートテスト","SQL Server","保守\nテスト","体制人数：2-5人"]
    contents << ["2018/7\n-\n2018/9\n\n3ヶ月","ECサイトバッチ開発","・バッチ開発","ASTERIA Warp/JP1\nSQL Server","製造\nテスト","体制人数：6人"]
    contents << ["2018/2\n-\n2018/7\n\n6ヶ月","プログラミング研修","・Javaサーバーサイド\n・モバイルアプリ開発","Java\nservlet/JSP\nAndroid Studio\nSQL\nGit","設計\n製造\nテスト",""]
    # contents << ["2015/10\n-\n2018/2\n\n29ヶ月","2DCG制作","2DCGゲーム背景作成","Photoshop","","体制人数：1人"]
    # contents << ["2007/4\n-\n2009/6\n\n27ヶ月","建築設計／都市デザイン","・建築設計、土木設計\n・CADを使った作図\n・グラフ、統計資料など各種ドキュメント作成","","",""]
    # contents << ["2004/5\n-\n2006/8\n\n28ヶ月","経営管理事務","・経営計画立案\n・株式上場に向けたアクション\n・議事録など各種ドキュメント作成","","","体制人数：4人\n役職：部長"]
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
