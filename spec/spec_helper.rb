# frozen_string_literal: true

# Enable code coverage if requested
if ENV['SIMPLECOV'] == 'true'
  require 'simplecov'
  require 'simplecov-cobertura'

  SimpleCov.start do
    enable_coverage :branch
    add_filter '/spec/'
    add_filter '/vendor/'

    # Generate HTML and Cobertura XML reports
    formatter SimpleCov::Formatter::MultiFormatter.new([
                                                         SimpleCov::Formatter::HTMLFormatter,
                                                         SimpleCov::Formatter::CoberturaFormatter
                                                       ])
  end
end

require 'satelliteapi'
require 'webmock/rspec'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
