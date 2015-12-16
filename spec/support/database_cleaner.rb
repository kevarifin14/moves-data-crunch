require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    # In case we did an unclean shutdown on a previous run.
    # Will be relevant once we're doing feature specs.
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
