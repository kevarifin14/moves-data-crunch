require 'rails_helper'

RSpec.describe Moves::ApiClient do
  let(:access_token) { '1234' }

  let!(:client) { described_class.new(access_token: access_token) }
  let(:first_date) { Date.parse('2015-09-30') }
  let(:moves_client) { Moves::Client.new(access_token) }

  let(:profile_json) do
    {
      'userId' => 23_138_311_640_030_064,
      'profile' => {
        'firstDate' => '20150930',
        'currentTimeZone' => {
          'id' => 'Europe/Helsinki',
          'offset' => 10_800,
        },
        'localization' => {
          'language' => 'en',
          'locale' => 'fi_FI',
          'firstWeekDay' => 2,
          'metric' => true,
        },
        'caloriesAvailable' => true,
        'platform' => 'ios',
      },
    }
  end

  let(:monthly_activity_json) do
    [
      {
        'date' => '20151201',
        'summary' => [
          {
            'activity' => 'walking',
            'group' => 'walking',
            'duration' => 2852.0,
            'distance' => 2980.0,
            'steps' => 4412,
            'calories' => 175,
          },
          {
            'activity' => 'cycling',
            'group' => 'cycling',
            'duration' => 942.0,
            'distance' => 3693.0,
            'calories' => 98,
          },
          {
            'activity' => 'basketball',
            'duration' => 3000.0,
            'calories' => 324,
          },
        ],
        'caloriesIdle' => 1694,
        'lastUpdate' => '20151211T212955Z',
      },
      {
        'date' => '20151202',
        'summary' => [
          {
            'activity' => 'walking',
            'group' => 'walking',
            'duration' => 3276.0,
            'distance' => 3351.0,
            'steps' => 5038,
            'calories' => 197,
          },
          {
            'activity' => 'cycling',
            'group' => 'cycling',
            'duration' => 2034.0,
            'distance' => 7221.0,
            'calories' => 194,
          },
          {
            'activity' => 'weight_training',
            'duration' => 4264.0,
            'calories' => 334,
          },
        ],
        'caloriesIdle' => 1694,
        'lastUpdate' => '20151219T185036Z',
      },
    ]
  end

  let(:exercise_data_array) do
    [
      {
        name: 'Basketball',
        y: 3000.0,
      },
      {
        name: 'Dancing',
        y: 0.0,
      },
      {
        name: 'Weight Training',
        y: 4264.0,
      },
    ]
  end

  before do
    client.client = moves_client
    allow(Moves::Client).to receive(:new).and_return(moves_client)
    allow(moves_client).to receive(:profile).and_return(profile_json)
    allow(moves_client).to receive(:daily_summary)
      .with('2015-12').and_return(monthly_activity_json)
  end

  describe '#first_date' do
    specify { expect(client.first_date).to eq(first_date) }
  end

  describe '#month_data' do
    specify { expect(client.month_data).to eq([6331.0, 10_914]) }
  end

  describe '#exercise_month_date' do
    specify { expect(client.exercise_month_data).to eq(exercise_data_array) }
  end
end
