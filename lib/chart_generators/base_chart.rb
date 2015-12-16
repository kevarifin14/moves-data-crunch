require 'lazy_high_charts'
require './lib/constants/chart_colors'

module ChartGenerators
  # Provides general set up that can be included by chart generators
  class BaseChart
    def chart(chart_type:)
      LazyHighCharts::HighChart.new(chart_type) do |f|
        f.chart(
          defaultSeriesType: chart_type,
          style: { fontFamily: '"Roboto", "Helvetica Neue", sans-serif' },
          spacingTop: 30,
        )
        yield(f)
      end
    end
  end
end
