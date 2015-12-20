require './lib/chart_generators/base_chart'

module ChartGenerators
  module Dashboard
    # Generates pie chart for dashboard
    class PieChart
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
        base_chart.chart(chart_type: 'pie') do |f|
          f.title(text: 'Exercise Breakdown')
          f.series(exercise_data)
        end
      end

      private

      def exercise_data
        {
          type: 'pie',
          name: 'Duration',
          data: moves_client.exercise_month_data,
        }
      end
    end
  end
end
