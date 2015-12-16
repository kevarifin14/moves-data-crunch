ENV['RAILS_ENV'] ||= 'test'
require 'active_record'
require 'shoulda/matchers'
require 'factory_girl'
require 'byebug'
require 'yaml'
require './spec/support/database_cleaner'
require 'rspec/its'

unless defined?(Rails)
  database_yml = File.read('config/database.yml')
  database_yml_erb_parsed = ERB.new(database_yml).result
  connection_info = YAML.load(database_yml_erb_parsed).fetch('test')
  ActiveRecord::Base.establish_connection(connection_info)
  if ActiveRecord::Migrator.needs_migration?
    require_relative '../config/application'
    ActiveRecord::Base.maintain_test_schema = true
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

ActiveRecord::Migration.maintain_test_schema!

FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include(FactoryGirl::Syntax::Methods)
end
