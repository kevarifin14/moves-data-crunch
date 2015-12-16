require 'active_record_helper'
require './lib/chart_generators/base_chart'

RSpec.describe ChartGenerators::BaseChart do
  subject(:base_chart) { described_class.new }

  describe '#chart' do
    let(:chart_type) { 'line' }
    let(:filename) { 'chart' }

    subject do
      base_chart.chart(chart_type: chart_type) do |f|
        f.legend(enabled: false)
      end
    end

    it { is_expected.to be_a(LazyHighCharts::HighChart) }

    its(:options) do
      is_expected.to eq(
        title: { text: nil },
        legend: { enabled: false },
        xAxis: {},
        yAxis: {
          title: { text: nil },
          labels: {},
        },
        tooltip: { enabled: true },
        credits: { enabled: false },
        plotOptions: { areaspline: {} },
        chart: {
          defaultSeriesType: chart_type,
          style: { fontFamily: '"Roboto", "Helvetica Neue", sans-serif' },
          spacingTop: 30,
        },
        subtitle: {},
      )
    end
  end
end
