require 'rails_helper'

RSpec.describe DashboardController do
  describe 'routing' do
    include_context 'authenticated as a User'

    it 'routes to #show' do
      expect(get: '/').to route_to('dashboard#show')
    end
  end
end
