# SatelliteAPI

[![Ruby](https://github.com/skyethepinkcat/ruby-satelliteapi/actions/workflows/ruby.yml/badge.svg)](https://github.com/skyethepinkcat/ruby-satelliteapi/actions/workflows/ruby.yml)
[![codecov](https://codecov.io/gh/skyethepinkcat/ruby-satelliteapi/branch/main/graph/badge.svg)](https://codecov.io/gh/skyethepinkcat/ruby-satelliteapi)

I mostly used fuckin' copilot to write this so treat it with as much grace as I did

A Ruby library for interacting with Red Hat Satellite API endpoints. This gem provides a simple and intuitive interface for making API calls to Satellite servers, supporting both standard Satellite API and Katello API endpoints.


## Installation

This gem is available through GitHub Packages. You'll need to configure your environment to use GitHub Packages as a gem source.

### Configure GitHub Packages Access

First, you need to authenticate with GitHub Packages. Create a personal access token with `read:packages` permission at https://github.com/settings/tokens.

Then configure bundler to use GitHub Packages:

```bash
bundle config --global https://rubygems.pkg.github.com/skyethepinkcat USERNAME:TOKEN
```

Replace `USERNAME` with your GitHub username and `TOKEN` with your personal access token.

### Install the Gem

Add this line to your application's Gemfile:

```ruby
source 'https://rubygems.pkg.github.com/skyethepinkcat' do
  gem 'satelliteapi'
end
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install satelliteapi --source https://rubygems.pkg.github.com/skyethepinkcat
```

## Usage

### Basic Setup

```ruby
require 'satelliteapi'

# Initialize the API client
api = SatelliteApi::Api.new(
  'https://satellite.example.com',
  'your_username',
  'your_password'
)
```

### Configuration Options

```ruby
# Enable verbose mode for debugging
api = SatelliteApi::Api.new(
  'https://satellite.example.com',
  'username',
  'password',
  verbose: true
)

# Custom SSL verification (useful for self-signed certificates)
api = SatelliteApi::Api.new(
  'https://satellite.example.com',
  'username',
  'password',
  verify_ssl: OpenSSL::SSL::VERIFY_NONE
)
```

### Making API Calls

#### GET Requests

```ruby
# Get all hosts
hosts = api.get('/hosts')

# Get content views (using Katello API)
content_views = api.get('/content_views', katello: true)

# Get specific host
host = api.get('/hosts/1')
```

#### POST Requests

```ruby
# Create a new host
new_host = api.post('/hosts', {
  'host' => {
    'name' => 'new-server.example.com',
    'organization_id' => 1,
    'location_id' => 1
  }
})

# Create content view (Katello API)
content_view = api.post('/content_views', {
  'name' => 'My Content View',
  'organization_id' => 1
}, katello: true)
```

#### PUT Requests

```ruby
# Update a host
updated_host = api.put('/hosts/1', {
  'host' => {
    'comment' => 'Updated via API'
  }
})
```

#### DELETE Requests

```ruby
# Delete a host
api.delete('/hosts/1')

# Delete content view (Katello API)
api.delete('/content_views/1', katello: true)
```

#### Custom HTTP Methods

```ruby
# Use any HTTP method with the generic request method
result = api.request(:patch, '/hosts/1', payload: { 'host' => { 'enabled' => false } })
```

### Error Handling

```ruby
begin
  result = api.get('/hosts')
  puts "Found #{result['results'].length} hosts"
rescue RestClient::ExceptionWithResponse => e
  puts "API Error: #{e.response.code} - #{e.response.body}"
rescue StandardError => e
  puts "Error: #{e.message}"
end
```

### Working with Responses

All API methods return parsed JSON as Ruby hashes:

```ruby
hosts = api.get('/hosts')

# Access response data
puts "Total hosts: #{hosts['total']}"
puts "Results per page: #{hosts['per_page']}"

# Iterate through results
hosts['results'].each do |host|
  puts "Host: #{host['name']} (#{host['ip']})"
end
```

## API Reference

### `SatelliteApi::Api.new(instance_url, username, password, options = {})`

Creates a new API client instance.

**Parameters:**
- `instance_url` (String): The base URL of your Satellite server
- `username` (String): Your Satellite username
- `password` (String): Your Satellite password
- `verbose` (Boolean, optional): Enable verbose logging (default: false)
- `verify_ssl` (Integer, optional): SSL verification mode (default: OpenSSL::SSL::VERIFY_NONE)

### Instance Methods

#### `get(path, katello: false)`
Performs a GET request to the specified path.

#### `post(path, payload, katello: false)`
Performs a POST request with the given payload.

#### `put(path, payload, katello: false)`
Performs a PUT request with the given payload.

#### `delete(path, katello: false)`
Performs a DELETE request to the specified path.

#### `request(method, path, payload: nil)`
Performs a request with any HTTP method.

**Parameters for all methods:**
- `path` (String): API endpoint path (e.g., '/hosts', '/content_views')
- `payload` (Hash): Request payload for POST/PUT requests
- `katello` (Boolean): Use Katello API endpoints instead of standard Satellite API

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run tests with coverage
SIMPLECOV=true bundle exec rspec

# Run linting
bundle exec rubocop
```

### Publishing

This gem is automatically published to GitHub Packages when the version is incremented and changes are pushed to the main branch. The CI/CD pipeline handles the publishing process.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/skyethepinkcat/ruby-satelliteapi.

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write tests for your changes
4. Ensure all tests pass (`bundle exec rspec`)
5. Ensure code style compliance (`bundle exec rubocop`)
6. Commit your changes (`git commit -am 'Add some feature'`)
7. Push to the branch (`git push origin my-new-feature`)
8. Create a new Pull Request

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Changelog

### Version 0.1.1
- Added comprehensive test suite
- Improved error handling
- Fixed URL construction for Katello API endpoints
- Added GitHub Actions CI/CD pipeline

### Version 0.1.0
- Initial release
- Basic API client functionality
- Support for GET, POST, PUT, DELETE operations
- Katello API endpoint support

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
