# require 'active_record_helper'
require 'active_record_helper'
require 'shoulda/matchers'
require './app/models/user'

RSpec.describe User do
  subject { build_stubbed(described_class) }

  describe 'columns' do
    it do
      is_expected.to have_db_column(:email).of_type(:string)
        .with_options(
          default: '',
          null: false,
        )
    end
    it { is_expected.to have_db_column(:access_token).of_type(:string) }
  end
end
