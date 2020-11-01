require_relative '../services/get_chart_list_service.rb'
require_relative '../services/make_time_series_service.rb'

class StudiesController < ApplicationController
  include ApplicationHelper

  def pie_data(past_sub, past_time)
    past_sub.size.times { |n| past_sub[n] = [past_time[n], past_sub[n]]}
    past_sub = past_sub.sort.reverse
    # その他を最後にする処理
    past_sub.size.times do |n|
      if past_sub[n][1] == "その他"
        past_sub << past_sub[n]
        past_sub.delete_at(n)
      end
    end
    pie = []
    past_sub.size.times do |n|
      pie << { name: past_sub[n][1], y: past_sub[n][0]}
    end
    pie
  end

  def chart
    seq = Study.all
    # その他に含める項目
    other_keys = ['unity', 'connpass', 'cobol', 'vba']
    # データ開始日
    start_day = '2018-02-01'
    # 各項目のグラフ表記名
    names = { 
      total: '総計',
      other: 'その他',
      'java': 'java', 
      'sql': 'SQL',
      'asteria': 'ECサイトバッチプログラム(ASTERIA Warp/JP1)',
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

    get_chart_list_service = GetChartListService.new(seq, other_keys, start_day, names)
    x_months = get_chart_list_service.get_x_months
    seq_keys = get_chart_list_service.get_seq_keys
    chart_list = get_chart_list_service.get_chart
    # debugger

    chart_title = '時系列 推移'
    make_time_series_service = MakeTimeSeriesService.new(chart_title, chart_list)
    @chart0 = make_time_series_service.make_series

    t = []
    chart_list.each_value {|e| t << e[:total].to_i}
    @subject_times = t

    past_sub = ["Java","JavaScript","SQL","PHP","Android","servlet/JSP","基本情報技術者試験","ECサイト開発(ASTERIA Warp/JP1)","電子カルテ保守","その他","Ruby on Rails"]
    past_time = [258,126,720,19,83,121,147,224+72,864,26,386]

    @chart1 = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "開発経験 total: #{past_time.inject(:+)} 時間")
      c.series({ colorByPoint: true, data: pie_data(past_sub, past_time) })
      c.plotOptions(pie: {
        allowPointSelect: true,
        cursor: 'pointer',
        dataLabels: {
          enabled: true,
          format: '{point.name}: {y} 時間 ({point.percentage:.1f} %)',
        }
      })
      c.chart(type: "pie")
    end

    @jobs = []
    titles = [:dates, :subject, :task, :language, :category, :team]
    contents = []
    contents << ["2004/5\n-\n2006/8\n\n28ヶ月","経営管理事務","・経営計画立案\n・株式上場に向けたアクション\n・議事録など各種ドキュメント作成","","","体制人数：4人\n役職：部長"]
    contents << ["2007/4\n-\n2009/6\n\n27ヶ月","建築設計／都市デザイン","・建築設計、土木設計\n・CADを使った作図\n・グラフ、統計資料など各種ドキュメント作成","","",""]
    contents << ["2015/10\n-\n2018/2\n\n29ヶ月","2DCG制作","2DCGゲーム背景作成","Photoshop","","体制人数：1人"]
    contents << ["2018/2\n-\n2018/7\n\n6ヶ月","プログラミング研修","・Javaサーバーサイド\n・モバイルアプリ開発","Java\nservlet/JSP\nAndroid\nSQL\nPHP","設計\n製造\nテスト",""]
    contents << ["2018/7\n-\n2018/9\n\n3ヶ月","ECサイト開発","・サーバーサイド\n・データベース","ASTERIA Warp/JP1","製造\nテスト","体制人数：6人"]
    contents << ["2018/10\n-\n2019/9\n\n12ヶ月","電子カルテシステム保守","・顧客対応\n・データベースリカバリ\n・アップデートテスト","SQL","保守\nテスト","体制人数：2-5人"]
    contents << ["2019/10\n-\n2020/1\n\n4ヶ月","自習","・Rails Tutorial\n・Ruby入門書（プロを目指す人のためのRuby入門）\n・自作アプリ開発「Flashcards」","Ruby on Rails","設計\n製造\nテスト",""]
    contents.size.times do |i|
      job = {}
      titles.each_with_index do |title, j|
        job[title] = hbr(contents[i][j])
      end
      @jobs << job
    end

    @summary = []
    titles = [:age, :sex, :work_months, :qualification]
    contents = []
    contents << ["38","男","25ヶ月","基本情報技術者\nOracle Java Silver SE 8\nTOEIC 840点"]
    contents.size.times do |i|
      summary = {}
      titles.each_with_index do |title, j|
        summary[title] = hbr(contents[i][j])
      end
      @summary << summary
    end
  end
end
