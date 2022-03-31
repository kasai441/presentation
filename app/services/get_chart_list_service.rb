# frozen_string_literal: true

class GetChartListService
  def initialize(seq, key_groups, start_day, names)
    @seq = seq
    @key_groups = key_groups
    @start_day = start_day
    @names = names
    @x_months = {}
  end

  attr_reader :seq, :key_groups, :start_day, :names, :x_months

  def get_chart
    # 初期化、総時間を最初にセット
    chart_list = { total: { key: :total, name: names[:total] }.merge(aggregate_time(:total)) }
    # キーグループごとにまとめる
    key_groups.each do |key, value|
      seq.map { |e| e.subject = key.to_sym if value.include?(e.subject) }
    end
    # キーを取り出す
    seq_keys = seq.map(&:subject).uniq
    # キーごとに時間集計
    seq_keys.each do |key|
      next if key == :other.to_s

      chart_list[key.downcase.gsub('-', '_').to_sym] = { key: key, name: names[key.to_sym] }.merge(aggregate_time(key))
    end
    chart_list = chart_list.sort { |a, b| a[1][:total] <=> b[1][:total] }.reverse.to_h
    # その他を最後にセット
    chart_list[:other] = { key: :other.to_s, name: names[:other] }.merge(aggregate_time(:other.to_s))
    # debugger

    chart_list
  end

  private

  def aggregate_time(chart_sub)
    ready_x_months
    seq.size.times do |n|
      start_time = seq[n].started_at
      t = seq[n].ended_at - start_time
      # :totalは全レコード、他は各subjectごとに秒で集計
      x_months["#{start_time.month}-#{start_time.year}"] += t if chart_sub == :total || chart_sub == seq[n].subject
    end
    # 秒を時間に
    x_months.each_key { |e| x_months[e] = (x_months[e] / 3600).round(2) }

    dates = []
    times = []
    total = 0
    x_months.each do |key, value|
      dates << key
      times << value
      total += value
    end
    { dates: dates, times: times, total: total }
  end

  def ready_x_months
    key_time = Time.zone.parse(start_day)
    now_time = Time.zone.now
    loop do
      x_months["#{key_time.month}-#{key_time.year}"] = 0
      key_time += 1.months
      break if key_time > now_time
    end
  end
end
