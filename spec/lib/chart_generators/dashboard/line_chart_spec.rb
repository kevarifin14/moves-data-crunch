require 'rails_helper'
require 'lazy_high_charts'
require './lib/chart_generators/dashboard/line_chart'
require 'moves'

RSpec.describe ChartGenerators::Dashboard::LineChart do
  subject(:line_chart_generator) do
    described_class.call(moves_client: moves_client)
  end

  let(:moves_client) { Moves::ApiClient.new(access_token: '1234') }

  before do
    allow(moves_client).to receive(:cumulative_line_data)
      .and_return(line_data)
    allow(Date).to receive(:today).and_return(Date.parse('2015-12-30'))
  end

  let(:line_data) do
    [
      {
        name: 'Walking',
        data: [100.0, 200.0],
      },
      {
        name: 'Cycling',
        data: [100.0, 200.0],
      },
      {
        name: 'Running',
        data: [0.0, 100.0],
      },
    ]
  end

  it { is_expected.to be_an_instance_of(LazyHighCharts::HighChart) }

  its(:series_data) do
    is_expected.to eq(line_data)
  end

  its(:options) do
    is_expected.to eq(
      title: { text: 'Cumulative Data' },
      chart: {
        defaultSeriesType: 'line',
        style: {
          fontFamily: '"Roboto", "Helvetica Neue", sans-serif'
        },
        spacingTop: 30,
      },
      xAxis: {
        title: { text: 'Date' },
        categories: (Time.zone.today.beginning_of_month..Time.zone.today).to_a,
      },
      yAxis: {
        min: 0,
        title: { text: 'Distance (m)' },
        gridLineColor: '#EEE',
      },
      tooltip: { valueSuffix: ' meters' },
      credits: { enabled: false },
      legend: { enabled: false },
      plotOptions: { areaspline: {} },
      subtitle: {},
    )
  end
end
