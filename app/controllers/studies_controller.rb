class StudiesController < ApplicationController
  include ApplicationHelper
  def total_chart(seq, x_months, chart_sub)
    x_months.keys.each { |e| x_months[e] = 0 }
    seq.size.times do |n|
      t = seq[n].ended_at - seq[n].started_at
      if chart_sub == :total
        # debugger
        x_months[seq[n].started_at.month.to_s] += t
      else
        case seq[n].subject
        when chart_sub
          x_months[seq[n].started_at.month.to_s] += t
        end
      end
    end
    x_months.keys.each { |e| x_months[e] = (x_months[e] / 3600).round(2) }

    date = []
    time = []
    total = 0
    x_months.each do |key, value|
      date << key
      time << value
      total += value
    end
    { :date=>date, :time=>time, :total=>total }
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
    firstmonth = Time.zone.parse('2019-04-23').month
    # months = Time.zone.today.month - firstmonth + 1
    months = 2 - firstmonth + 1
    months += 12 if months < 1

    x_months = {}
    months.times do |n|
      key = firstmonth + n
      key -= 12 if key > 12
      x_months[(key).to_s] = 0
    end

    total_chart = total_chart(seq, x_months, :total)
    progate_chart = total_chart(seq, x_months, "Progate")
    railstutorial_chart = total_chart(seq, x_months, "Railstutorial")
    cherrybook_chart = total_chart(seq, x_months, "CherryBook")
    flashcards_chart = total_chart(seq, x_months, "Flashcards")

    @chart0 = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "Railsの勉強時間")
      c.xAxis(categories: total_chart[:date].map { |e| e + "月" })
      c.series(name: "total: #{total_chart[:total].to_i} 時間", data: total_chart[:time], type: "column")
      c.series(name: "Progate 各種講座: #{progate_chart[:total].to_i} 時間", data: progate_chart[:time])
      c.series(name: "Rails Tutorial: #{railstutorial_chart[:total].to_i} 時間", data: railstutorial_chart[:time])
      c.series(name: "Ruby入門書（プロを目指す人のためのRuby入門）: #{cherrybook_chart[:total].to_i} 時間", data: cherrybook_chart[:time])
      c.series(name: "自作アプリ開発「Flashcards」: #{flashcards_chart[:total].to_i} 時間", data: flashcards_chart[:time])
      c.chart(type: "line")
    end

    @subject_times = subject_times(seq)

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

  def total_chart_day(seq, x_dates, chart_sub)
    x_dates.keys.each { |e| x_dates[e] = 0 }
    seq.size.times do |n|
      t = seq[n].ended_at - seq[n].started_at
      if chart_sub == :total
        x_dates[seq[n].started_at.to_date.to_s] += t
      else
        case seq[n].subject
        when chart_sub
          x_dates[seq[n].started_at.to_date.to_s] += t
        end
      end
    end
    x_dates.keys.each { |e| x_dates[e] = (x_dates[e] / 3600).round(2) }

    date = []
    time = []
    total = 0
    x_dates.each do |key, value|
      date << key
      time << value
      total += value
    end
    { :date=>date, :time=>time, :total=>total }
  end

  def chart_day
    seq = Study.all
    firstday = Time.zone.parse('2019-04-23').to_date
    dates = (Time.zone.today.to_date - firstday).to_i
    x_dates = {}
    dates.times do |n|
      x_dates[(firstday + n).to_s] = 0
    end

    total_chart = total_chart(seq, x_dates, :total)
    progate_chart = total_chart(seq, x_dates, "Progate")
    railstutorial_chart = total_chart(seq, x_dates, "Railstutorial")
    cherrybook_chart = total_chart(seq, x_dates, "CherryBook")
    flashcards_chart = total_chart(seq, x_dates, "Flashcards")

    @chart0 = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "Railsの勉強時間")
      c.xAxis(categories: total_chart[:date])
      c.series(name: "total: #{total_chart[:total].to_i} 時間", data: total_chart[:time])
      c.series(name: "Progate: #{progate_chart[:total].to_i} 時間", data: progate_chart[:time])
      c.series(name: "Railstutorial: #{railstutorial_chart[:total].to_i} 時間", data: railstutorial_chart[:time])
      c.series(name: "CherryBook: #{cherrybook_chart[:total].to_i} 時間", data: cherrybook_chart[:time])
      c.series(name: "Flashcards: #{flashcards_chart[:total].to_i} 時間", data: flashcards_chart[:time])
      # c.series({ data: [{
      #   name: "Progate: #{progate_chart[:total].to_i} 時間", y: progate_chart[:time]
      # }, {
      #   name: "Railstutorial: #{railstutorial_chart[:total].to_i} 時間", y: railstutorial_chart[:time]
      # }] })
      c.chart(type: "column")
    end

    @subject_times = subject_times(seq)

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

  end
end
