require './lib/chart_generators/base_chart'

module ChartGenerators
  module Dashboard
    # Generates column charts for dashboard
    class LineChart
      attr_accessor :moves_client, :chart_colors, :base_chart

      def self.call(moves_client:)
        new(moves_client: moves_client).call
      end

      def initialize(moves_client:)
        @moves_client = moves_client
        @chart_colors = Constants::CHART_COLORS
        @base_chart = ChartGenerators::BaseChart.new
      end

      def call
        base_chart.chart(
          chart_type: 'line',
        ) do |f|
          axes(f)
          f.title(
            text: 'Cumulative Data',
          )
          f.tooltip(valueSuffix: ' meters')
          moves_data.each do |data|
            f.series(data)
          end
          f.legend(enabled: false)
        end
      end

      private

      def moves_data
        moves_client.cumulative_line_data
      end

      def date_string
        Date::MONTHNAMES[Time.zone.today.month]
      end

      def axes(f)
        f.xAxis(x_axis)
        f.yAxis(y_axis)
      end

      def x_axis
        {
          title: { text: 'Date' },
          categories:
            (Time.zone.today.beginning_of_month..Time.zone.today).to_a,
        }
      end

      def y_axis
        {
          min: 0,
          title: { text: 'Distance (m)' },
          gridLineColor: chart_colors.fetch(:grey_light),
        }
      end
    end
  end
end
