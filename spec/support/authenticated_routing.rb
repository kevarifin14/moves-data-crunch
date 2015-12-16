RSpec.shared_context 'authenticated routing' do
  let(:warden) do
    instance_double('Warden::Proxy').tap do |warden|
      allow(warden).to receive(:authenticate!).with(scope: :user)
        .and_return(authenticated?)
      allow(warden).to receive(:user).with(:user).and_return(user)
    end
  end

  def simulate_running_with_devise
    stub_const(
      'Rack::MockRequest::DEFAULT_ENV',
      Rack::MockRequest::DEFAULT_ENV.merge('warden' => warden),
    )
  end

  before { simulate_running_with_devise }
end

RSpec.shared_context 'authenticated as a User' do
  include_context 'authenticated routing'
  let(:authenticated?) { true }
  let(:user) { build_stubbed(User) }
end
