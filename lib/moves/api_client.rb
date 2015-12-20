require 'method_object'
require 'moves'

module Moves
  # Custom api client class for moves
  class ApiClient
    DATA_MAP = {
      'walking' => 0,
      'cycling' => 1,
    }
    attr_accessor :client

    def initialize(access_token:)
      @client = Moves::Client.new(access_token)
    end

    def first_date
      Date.parse(profile.fetch('firstDate'))
    end

    def month_data
      sums = [0.0, 0.0]
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
