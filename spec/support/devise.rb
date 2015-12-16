# Macros for testing devise authentication in controllers
module DeviseMacros
  def self.extended(base)
    base.include(Devise::TestHelpers)
  end

  # An includable module that provides a method to login a specified user
  module LoginUser
    def login_user(user)
      @request.env['devise.mapping'] = Devise.mappings.fetch(:user)
      sign_in(user)
    end
  end
end

RSpec.configure do |config|
  config.extend(DeviseMacros, type: :controller)
  config.include(DeviseMacros::LoginUser, type: :controller)
end
