require 'rails_helper'
require 'lazy_high_charts'
require './lib/chart_generators/dashboard/column_chart'
require 'moves'

RSpec.describe ChartGenerators::Dashboard::ColumnChart do
  subject(:column_chart_generator) do
    described_class.call(moves_client: moves_client)
  end

  let(:moves_client) { Moves::Client.new('1234') }

  let(:daily_summary_hash) do
    [{
      'summary' => [
        {
          'distance' => 100.0
        },
        {
          'distance' => 200.0
        },
      ]
    }]
  end

  before do
    allow(moves_client).to receive(:daily_summary)
      .and_return(daily_summary_hash)
  end

  it { is_expected.to be_an_instance_of(LazyHighCharts::HighChart) }

  its(:series_data) do
    is_expected.to eq(
      [
        {
          name: 'Walking',
          data: [100.0],
          color: '#1BC98E',
        },
        {
          name: 'Cycling',
          data: [200.0],
          color: '#1CA8DD',
        },
      ]
    )
  end

  its(:options) do
    is_expected.to eq(
      title: { text: nil },
      chart: {
        defaultSeriesType: 'column',
        style: {
          fontFamily: '"Roboto", "Helvetica Neue", sans-serif'
        },
        spacingTop: 30,
      },
      xAxis: { categories: %w[Walking Cycling] },
      yAxis: {
        min: 0,
        title: { text: nil },
        gridLineColor: '#EEE',
      },
      tooltip: { valueSuffix: ' meters' },
      credits: { enabled: false },
      legend: { layout: 'vertical', style: {} },
      plotOptions: { areaspline: {} },
      subtitle: {},
    )
  end
end
