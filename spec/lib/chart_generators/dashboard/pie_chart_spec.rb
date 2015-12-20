require 'rails_helper'
require 'lazy_high_charts'
require './lib/chart_generators/dashboard/pie_chart'
require 'moves'

RSpec.describe ChartGenerators::Dashboard::PieChart do
  subject(:pie_chart_generator) do
    described_class.call(moves_client: moves_client)
  end

  let(:moves_client) { Moves::ApiClient.new(access_token: '1234') }

  before do
    allow(moves_client).to receive(:exercise_month_data)
      .and_return([
        {
          name: 'Basketball',
          y: 100.0,
        },
        {
          name: 'Dancing',
          y: 0.0,
        },
        {
          name: 'Weight Training',
          y: 200.0,
        },
      ])
    allow(Date).to receive(:today).and_return(Date.parse('2015-12-30'))
  end

  it { is_expected.to be_an_instance_of(LazyHighCharts::HighChart) }

  its(:series_data) do
    is_expected.to eq(
      [
        {
          type: 'pie',
          name: 'Duration',
          data: [
            {
              name: 'Basketball',
              y: 100.0,
            },
            {
              name: 'Dancing',
              y: 0.0,
            },
            {
              name: 'Weight Training',
              y: 200.0,
            },
          ],
        },
      ]
    )
  end

  its(:options) do
    is_expected.to eq(
      title: { text: 'Exercise Breakdown' },
      chart: {
        defaultSeriesType: 'pie',
        style: {
          fontFamily: '"Roboto", "Helvetica Neue", sans-serif'
        },
        spacingTop: 30,
      },
      tooltip: { enabled: true },
      credits: { enabled: false },
      plotOptions: { areaspline: {} },
      subtitle: {},
      legend: { layout: 'vertical', style: {} },
      xAxis: {},
      yAxis: { title: { text: nil }, labels: {} },
    )
  end
end
