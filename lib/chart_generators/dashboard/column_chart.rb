require './lib/chart_generators/base_chart'

module ChartGenerators
  module Dashboard
    # Generates stacked column charts for dashboard
    class ColumnChart
      DATA_MAP = {
        'walking' => 0,
        'cycling' => 1,
      }
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
          f.title(text: 'Past Month Cycling and Walking Distance Totals')
          f.tooltip(valueSuffix: ' meters')
          f.series(moves_data)
          f.legend(enabled: false)
        end
      end

      private

      def moves_data
        {
          name: 'Distance',
          data: data_array,
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

      def data_array
        sums = [0.0, 0.0]
        daily_summary_array.each do |daily_activity|
          daily_activity.fetch('summary').each do |activity|
            activity_name = activity.fetch('activity')
            if DATA_MAP.key?(activity_name)
              sums[DATA_MAP.fetch(activity_name)] += activity.fetch('distance')
            end
          end
        end
        sums
      end

      def daily_summary_array
        moves_client.daily_summary(pastDays: 31)
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
