# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :deletion
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
