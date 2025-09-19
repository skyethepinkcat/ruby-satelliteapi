# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in satelliteapi.gemspec
gemspec

group :production do
  gem 'rake', '~> 13.0'
  gem 'rest-client'
end

group :development do
  gem 'irb'
  gem 'rubocop'
  gem 'ruby-lsp'
end

group :test do
  gem 'rspec'
  gem 'simplecov'
  gem 'simplecov-cobertura'
  gem 'webmock'
end
