class MakeTimeSeriesService
  def initialize(chart_title, chart_list)
    @chart_title = chart_title
    @chart_list = chart_list
  end

  attr_reader :chart_title, :chart_list

  def make_series
    # debugger
    @chart0 = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: chart_title)
      c.xAxis(categories: chart_list[:total][:dates])
      chart_list.each_value do |chart|
        c.series(
          name: "#{chart[:name]}: #{chart[:total].to_i} 時間", 
          data: chart[:times], 
          type: chart[:key] == :total ? 'column' : ''
        )
      end
      c.chart(type: "line", height: 400)
    end 
    return @chart0
  end
end  
