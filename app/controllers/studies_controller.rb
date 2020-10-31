class StudiesController < ApplicationController
  include ApplicationHelper
  def total_chart(seq, x_months, chart_sub)
    seq.size.times do |n|
      start_time = seq[n].started_at
      # debugger
      t = seq[n].ended_at - start_time
      if chart_sub == :total || chart_sub == seq[n].subject  
        x_months[start_time.month.to_s + "-" + start_time.year.to_s] += t
      end
    end
    # 秒を時間に
    x_months.keys.each { |e| x_months[e] = (x_months[e] / 3600).round(2) }

    dates = []
    times = []
    total = 0
    x_months.each do |key, value|
      dates << key
      times << value
      total += value
    end
    { :dates=>dates, :times=>times, :total=>total }
  end

  def subject_times(seq)
    p = r = c = f = 0
    seq.size.times do |n|
      t = seq[n].ended_at - seq[n].started_at
      case seq[n].subject
      when "Progate"
        p += t
      when "Railstutorial"
        r += t
      when "CherryBook"
        c += t
      when "Flashcards"
        f += t
      else
      end
    end
    subject_times = [p, r, c, f].map { |e| (e / 3600).to_i }
  end

  def pie_data(past_sub, past_time)
    past_sub.size.times { |n| past_sub[n] = [past_time[n], past_sub[n]]}
    past_sub = past_sub.sort.reverse
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
    key_time = Time.zone.parse('2018-02-01')
    now_time = Time.zone.now

    x_months = {}
    while key_time < now_time do
      x_months[key_time.month.to_s + "-" + key_time.year.to_s] = 0
      key_time += 1.months
    end

    # debugger

    total_chart = total_chart(seq, x_months, :total)
    java_chart = total_chart(seq, x_months, "java")
    sql_chart = total_chart(seq, x_months, "sql")
    asteria_chart = total_chart(seq, x_months, "asteria")
    hospital_system_chart = total_chart(seq, x_months, "hospital-system")
    progate_chart = total_chart(seq, x_months, "Progate")
    railstutorial_chart = total_chart(seq, x_months, "Railstutorial")
    cherrybook_chart = total_chart(seq, x_months, "CherryBook")
    flashcards_chart = total_chart(seq, x_months, "Flashcards")
    presentation_chart = total_chart(seq, x_months, "presentation")
    paiza_chart = total_chart(seq, x_months, "paiza")
    atcoder_chart = total_chart(seq, x_months, "atcoder")
    aizu_chart = total_chart(seq, x_months, "aizu")
    # unity_chart = total_chart(seq, x_months, "unity")
    nyobiko_chart = total_chart(seq, x_months, "nyobiko")
    # connpass_chart = total_chart(seq, x_months, "connpass")
    # cobol_chart = total_chart(seq, x_months, "cobol")
    # vba_chart = total_chart(seq, x_months, "vba")
    batch_chart = total_chart(seq, x_months, "batch")
    javascript_chart = total_chart(seq, x_months, "JavaScript")

    @chart0 = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "プログラミング着手時間")
      # c.yAxis([0,50,100,150,200], )
      c.xAxis(categories: total_chart[:dates])
      c.series(name: "total: #{total_chart[:total].to_i} 時間", data: total_chart[:times], type: "column")
      c.series(name: "Java: #{java_chart[:total].to_i} 時間", data: java_chart[:times])
      c.series(name: "SQL: #{sql_chart[:total].to_i} 時間", data: sql_chart[:times])
      c.series(name: "ECサイトバッチプログラム(ASTERIA Warp/JP1): #{asteria_chart[:total].to_i} 時間", data: asteria_chart[:times])
      c.series(name: "電子カルテ保守: #{hospital_system_chart[:total].to_i} 時間", data: hospital_system_chart[:times])
      c.series(name: "Progate 各種講座: #{progate_chart[:total].to_i} 時間", data: progate_chart[:times])
      c.series(name: "Rails Tutorial: #{railstutorial_chart[:total].to_i} 時間", data: railstutorial_chart[:times])
      c.series(name: "Ruby入門書（プロを目指す人のためのRuby入門）: #{cherrybook_chart[:total].to_i} 時間", data: cherrybook_chart[:times])
      c.series(name: "自作アプリ開発「Flashcards」: #{flashcards_chart[:total].to_i} 時間", data: flashcards_chart[:times])
      c.series(name: "ポートフォリオ開発（自作）: #{presentation_chart[:total].to_i} 時間", data: presentation_chart[:times])
      c.series(name: "paizaアルゴリズムテスト: #{paiza_chart[:total].to_i} 時間", data: paiza_chart[:times])
      c.series(name: "atcoderアルゴリズムテスト: #{atcoder_chart[:total].to_i} 時間", data: atcoder_chart[:times])
      c.series(name: "AIZU ONLINE JUDGE アルゴリズムテスト: #{aizu_chart[:total].to_i} 時間", data: aizu_chart[:times])
      # c.series(name: "unity: #{unity_chart[:total].to_i} 時間", data: unity_chart[:times])
      c.series(name: "N予備校 nodejs講座: #{nyobiko_chart[:total].to_i} 時間", data: nyobiko_chart[:times])
      # c.series(name: "connpass 勉強会: #{connpass_chart[:total].to_i} 時間", data: connpass_chart[:times])
      # c.series(name: "cobol: #{cobol_chart[:total].to_i} 時間", data: cobol_chart[:times])
      # c.series(name: "vba: #{vba_chart[:total].to_i} 時間", data: vba_chart[:times])
      c.series(name: "バッチプログラム開発: #{batch_chart[:total].to_i} 時間", data: batch_chart[:times])
      c.series(name: "JavaScript: #{javascript_chart[:total].to_i} 時間", data: javascript_chart[:times])
      c.chart(type: "line", height: 600)
    end

    t = []
    t.push(total_chart[:total].to_i)
    t.push(java_chart[:total].to_i)
    t.push(sql_chart[:total].to_i)
    t.push(asteria_chart[:total].to_i)
    t.push(hospital_system_chart[:total].to_i)
    t.push(progate_chart[:total].to_i)
    t.push(railstutorial_chart[:total].to_i)
    t.push(cherrybook_chart[:total].to_i)
    t.push(flashcards_chart[:total].to_i)
    t.push(presentation_chart[:total].to_i)
    t.push(paiza_chart[:total].to_i)
    t.push(atcoder_chart[:total].to_i)
    t.push(aizu_chart[:total].to_i)
    # t.push(unity_chart[:total].to_i)
    t.push(nyobiko_chart[:total].to_i)
    # t.push(connpass_chart[:total].to_i)
    # t.push(cobol_chart[:total].to_i)
    # t.push(vba_chart[:total].to_i)
    t.push(batch_chart[:total].to_i)
    t.push(javascript_chart[:total].to_i)
    # debugger

    # @subject_times = subject_times(seq)
    @subject_times = t

    past_sub = ["Java","JavaScript","SQL","PHP","Android","servlet/JSP","基本情報技術者試験","ECサイト開発(ASTERIA Warp/JP1)","電子カルテ保守","その他","Ruby on Rails"]
    past_time = [258,126,720,19,83,121,147,224+72,864,26,386]
    # current_sub = ["Java","JavaScript","SQL","nodejs","Spring","shell script","batch file"]
    # current_time = []

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

  # def total_chart_day(seq, x_dates, chart_sub)
  #   x_dates.keys.each { |e| x_dates[e] = 0 }
  #   seq.size.times do |n|
  #     t = seq[n].ended_at - seq[n].started_at
  #     if chart_sub == :total
  #       x_dates[seq[n].started_at.to_date.to_s] += t
  #     else
  #       case seq[n].subject
  #       when chart_sub
  #         x_dates[seq[n].started_at.to_date.to_s] += t
  #       end
  #     end
  #   end
  #   x_dates.keys.each { |e| x_dates[e] = (x_dates[e] / 3600).round(2) }

  #   date = []
  #   time = []
  #   total = 0
  #   x_dates.each do |key, value|
  #     date << key
  #     time << value
  #     total += value
  #   end
  #   { :date=>date, :time=>time, :total=>total }
  # end

  # def chart_day
  #   seq = Study.all
  #   firstday = Time.zone.parse('2019-04-23').to_date
  #   dates = (Time.zone.today.to_date - firstday).to_i
  #   x_dates = {}
  #   dates.times do |n|
  #     x_dates[(firstday + n).to_s] = 0
  #   end

  #   total_chart = total_chart(seq, x_dates, :total)
  #   progate_chart = total_chart(seq, x_dates, "Progate")
  #   railstutorial_chart = total_chart(seq, x_dates, "Railstutorial")
  #   cherrybook_chart = total_chart(seq, x_dates, "CherryBook")
  #   flashcards_chart = total_chart(seq, x_dates, "Flashcards")

  #   @chart0 = LazyHighCharts::HighChart.new("graph") do |c|
  #     c.title(text: "Railsの勉強時間")
  #     c.xAxis(categories: total_chart[:date])
  #     c.series(name: "total: #{total_chart[:total].to_i} 時間", data: total_chart[:time])
  #     c.series(name: "Progate: #{progate_chart[:total].to_i} 時間", data: progate_chart[:time])
  #     c.series(name: "Railstutorial: #{railstutorial_chart[:total].to_i} 時間", data: railstutorial_chart[:time])
  #     c.series(name: "CherryBook: #{cherrybook_chart[:total].to_i} 時間", data: cherrybook_chart[:time])
  #     c.series(name: "Flashcards: #{flashcards_chart[:total].to_i} 時間", data: flashcards_chart[:time])
  #     # c.series({ data: [{
  #     #   name: "Progate: #{progate_chart[:total].to_i} 時間", y: progate_chart[:time]
  #     # }, {
  #     #   name: "Railstutorial: #{railstutorial_chart[:total].to_i} 時間", y: railstutorial_chart[:time]
  #     # }] })
  #     c.chart(type: "column")
  #   end

  #   @subject_times = subject_times(seq)

    # seq = Study.all
    # date = []
    # time = []
    #
    # seq.size.times do |n|
    #   date << seq[n].started_at.to_date
    #   t = seq[n].ended_at - seq[n].started_at
    #   time << (t / 3600).round(2)
    # end
    #
    # @chart0 = LazyHighCharts::HighChart.new("graph") do |c|
    #   c.title(text: "Railsの勉強時間")
    #   c.xAxis(categories: date)
    #   c.series(name: "total", data: time)
    # end


    # wseq = Waitday.group(:wait_sequence).where(quizcard_id: User.first.quizcards.select("id")).count

    # wait_total = []
    # wseq.size.times do |num|
    #   wait_total << wseq[num]
    # end

    # wseq.size.times do |n|
    #   wseq[n] -= wseq[n + 1] if n < wseq.size - 1
    # end

    # wait_cards = []
    # wseq.size.times do |num|
    #   wait_cards << wseq[num]
    # end

    # wait_rate = {}
    # wseq.size.times do |num|
    #   seq = num
    #   wait = wseq[num]
    #   seq ||= 0
    #   wait ||= 0
    #   rate = 0.0
    #   rate =  wait.to_f / seq.to_f if seq > 0
    #   wait_rate[num + 1] = rate.round(2)
    # end

    # seq = wait_rate.size.times
    # @wait = []
    # seq.each do |s|
    #   @wait << wait_rate[s+1]
    # end

    # @chart0 = LazyHighCharts::HighChart.new("graph") do |c|
    #   c.title(text: "wait cards")
    #   c.xAxis(categories: seq)
    #   c.series(name: "cards", data: wait_cards)
    # end

    # @chart = LazyHighCharts::HighChart.new("graph") do |c|
    #   c.title(text: "wait rate")
    #   c.xAxis(categories: seq)
    #   c.series(name: "waitrate", data: @wait)
    # end

    # y = a * x + b
    # 213 = a * 31 + b
    # b = 213 - a * 31
    # 59 = a * 16 + b
    # b = 59 - a * 16
    # 213 - 59 = a * 31 - a * 16
    # 154 = a * 15
    # a = 154 / 15
    # b = -97

    # result = 0.00
    # 36500.times do |n|
    #   result += 1.00 / n.to_f / 10.00 if n > 0
    # end
    # result

    # result = 10.00
    # count = 0
    # 36500.times do |n|
    #   next if result > 36500
    #   result += n
    #   count += 1
    # end
    # count

  # end
end
