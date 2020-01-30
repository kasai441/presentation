class StudiesController < ApplicationController
  def subject_times(seq)
    p = r = c = f = 0
    seq.size.times do |n|
      t = seq[n].ended_at - seq[n].started_at
      t = (t / 3600).round(2)
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
    subject_times = [p, r, c, f]
    subject_times.map { |e| e.to_i }
  end

  def chart
    seq = Study.all
    firstday = Time.zone.parse('2019-04-23').to_date
    dates = (Time.zone.today.to_date - firstday).to_i
    x_dates = {}
    dates.times do |n|
      x_dates[(firstday + n).to_s] = 0
    end
    seq.size.times do |n|
      t = seq[n].ended_at - seq[n].started_at
      x_dates[seq[n].started_at.to_date.to_s] =+ (t / 3600).round(2)
    end

    date = []
    time = []
    total = 0
    x_dates.each do |key, value|
      date << key
      time << value
      total += value
    end

    @chart0 = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "Railsの勉強時間")
      c.xAxis(categories: date)
      c.series(name: "total: #{total.to_i} 時間", data: time)
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
