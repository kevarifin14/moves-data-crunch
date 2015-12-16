require 'rails_helper'

RSpec.describe DashboardController do
  let!(:user) { create(User, access_token: access_token) }

  before { login_user(user) }
  describe 'GET #show' do
    before do
      get :show
    end

    context 'user has access_token' do
      let(:access_token) { '1234' }
      specify { expect(response).to be_successful }
    end

    context 'user does not have access_token' do
      let(:access_token) { nil }
    end
  end
end
