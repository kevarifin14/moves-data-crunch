require 'method_object'
require 'moves'

module Moves
  # Custom api client class for moves
  class ApiClient
    DATA_MAP = {
      'walking' => 0,
      'cycling' => 1,
      'running' => 2,
    }

    EXERCISE_DATA_MAP = {
      'basketball' => 0,
      'dancing' => 1,
      'weight_training' => 2,
    }
    attr_accessor :client

    def initialize(access_token:)
      @client = Moves::Client.new(access_token)
    end

    def first_date
      Date.parse(profile.fetch('firstDate'))
    end

    def month_data
      sums = [0.0, 0.0, 0.0]
      monthly_summary(Time.zone.today).each do |daily_summary|
        next if activity_summary(daily_summary).nil?
        activity_summary(daily_summary).each do |activity|
          activity_name = activity.fetch('activity')
          if DATA_MAP.key?(activity_name)
            sums[DATA_MAP.fetch(activity_name)] += activity.fetch('distance')
          end
        end
      end
      sums
    end

    def exercise_month_data
      sums = [
        {
          name: 'Basketball',
          y: 0.0,
        },
        {
          name: 'Dancing',
          y: 0.0,
        },
        {
          name: 'Weight Training',
          y: 0.0,
        },
      ]
      monthly_summary(Time.zone.today).each do |daily_summary|
        next if activity_summary(daily_summary).nil?
        activity_summary(daily_summary).each do |activity|
          activity_name = activity.fetch('activity')
          if EXERCISE_DATA_MAP.key?(activity_name)
            sums[EXERCISE_DATA_MAP.fetch(activity_name)][:y] +=
              activity.fetch('duration')
          end
        end
      end
      sums
    end

    def cumulative_line_data
      sums = [
        {
          name: 'Walking',
          data: [0.0],
        },
        {
          name: 'Cycling',
          data: [0.0],
        },
        {
          name: 'Running',
          data: [0.0],
        },
      ]
      monthly_summary(Time.zone.today).each_with_index do |daily_summary, index|
        summary = activity_summary(daily_summary)
        next if summary.nil?
        DATA_MAP.each do |activity_name, sum_index|
          activity_data =
            summary.detect { |activity| activity['activity'] == activity_name }
          data_array = sums[sum_index].fetch(:data)
          if activity_data.nil?
            data_array[index] = data_array[index - 1]
          else
            data_array[index] =
              data_array[index - 1] + activity_data.fetch('distance')
          end
        end
      end
      sums
    end

    private

    def activity_summary(daily_summary)
      daily_summary.fetch('summary')
    end

    def monthly_summary(date)
      client.daily_summary("#{date.year}-#{date.month}")
    end

    def profile
      client.profile.fetch('profile')
    end

    def daily_activity
      moves_client.daily_summary.first.fetch('summary')
    end

    def daily_summary_array
      moves_client.daily_summary(pastDays: 31)
    end
  end
end
