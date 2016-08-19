RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  # When testing multiple db connections transaction doesn't because it isolate
  # connections from each other. See database_cleaner README for more info
  config.before(:each, multiple_db: true) do
    DatabaseCleaner.strategy = :truncation
  end

  # capybara functional tests - transaction does not work
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
