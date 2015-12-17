require './lib/chart_generators/base_chart'

module ChartGenerators
  module Dashboard
    # Generates stacked column charts for dashboard
    class ColumnChart
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
          chart_type: 'column',
        ) do |f|
          axes(f)
          f.tooltip(valueSuffix: ' meters')
          f.series(moves_data)
          f.legend(enabled: false)
        end
      end

      private

      def moves_data
        {
          name: 'Distance',
          data: [
            daily_activity.first.fetch('distance').to_f,
            daily_activity.second.fetch('distance').to_f,
          ],
          color: chart_colors.fetch(:green),
        }
      end

      def daily_activity
        moves_client.daily_summary.first.fetch('summary')
      end

      def axes(f)
        f.xAxis(categories: %w[Walking Cycling])
        f.yAxis(y_axis)
      end

      def y_axis
        {
          min: 0,
          title: { text: nil },
          gridLineColor: chart_colors.fetch(:grey_light),
        }
      end
    end
  end
end
