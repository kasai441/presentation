class MakePieService
  def initialize(chart_list)
    @names = []
    @times = []
    chart_list.delete(:total)
    chart_list.each_value do |value| 
      @names << value[:name]
      @times << value[:total]
    end
  end

  attr_reader :names, :times


  def make_pie
    @chart1 = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "開発経験 total: #{times.inject(:+).to_i} 時間")
      c.series({ colorByPoint: true, data: pie_data(names, times) })
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

    return @chart1
  end

  private

  def pie_data(names, times)
    names.size.times { |n| names[n] = [times[n].to_i, names[n]]}
    names = names.sort.reverse
    # その他を最後にする処理
    names.size.times do |n|
      if names[n][1] == "その他"
        names << names[n]
        names.delete_at(n)
      end
    end
    pie = []
    names.size.times do |n|
      if names[n] == :dummy
        pie << { name: names[n][1], y: names[n][0], color: '#000000'}
      else
        pie << { name: names[n][1], y: names[n][0] }
      end
    end
    pie
  end
end  
