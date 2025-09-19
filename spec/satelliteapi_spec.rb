# frozen_string_literal: true

require 'webmock/rspec'

RSpec.describe Satelliteapi do
  it 'has a version number' do
    expect(Satelliteapi::VERSION).not_to be_nil
  end
end

RSpec.describe SatelliteApi::Api do
  let(:instance_url) { 'https://satellite.example.com' }
  let(:username) { 'admin' }
  let(:password) { 'password' }
  let(:api) { described_class.new(instance_url, username, password) }

  describe '#initialize' do
    it 'sets the instance variables correctly' do
      expect(api.instance_url).to eq(instance_url)
      expect(api.username).to eq(username)
      expect(api.password).to eq(password)
      expect(api.api_url).to eq('/api')
      expect(api.katello_url).to eq('/katello/api')
      expect(api.verbose).to be(false)
    end

    it 'allows setting verbose mode' do
      verbose_api = described_class.new(instance_url, username, password, verbose: true)
      expect(verbose_api.verbose).to be(true)
    end

    it 'removes trailing slash from instance_url if present' do
      api_with_slash = described_class.new("#{instance_url}/", username, password)
      expect(api_with_slash.instance_url).to eq(instance_url)
    end
  end

  describe '#get' do
    before do
      stub_request(:get, "#{instance_url}/api/test")
        .with(
          basic_auth: [username, password],
          headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        )
        .to_return(status: 200, body: '{"result": "success"}', headers: { 'Content-Type' => 'application/json' })

      stub_request(:get, "#{instance_url}/katello/api/test")
        .with(
          basic_auth: [username, password],
          headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        )
        .to_return(status: 200, body: '{"result": "katello_success"}', headers: { 'Content-Type' => 'application/json' })
    end

    it 'performs a GET request to the API endpoint' do
      result = api.get('/test')
      expect(result).to eq({ 'result' => 'success' })
    end

    it 'performs a GET request to the Katello API endpoint when katello: true' do
      result = api.get('/test', katello: true)
      expect(result).to eq({ 'result' => 'katello_success' })
    end
  end

  describe '#post' do
    let(:payload) { { 'data' => 'test' } }

    before do
      stub_request(:post, "#{instance_url}/api/test")
        .with(
          basic_auth: [username, password],
          headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' },
          body: payload.to_json
        )
        .to_return(status: 200, body: '{"result": "post_success"}', headers: { 'Content-Type' => 'application/json' })
    end

    it 'performs a POST request with payload to the API endpoint' do
      result = api.post('/test', payload)
      expect(result).to eq({ 'result' => 'post_success' })
    end
  end

  describe '#put' do
    let(:payload) { { 'data' => 'update' } }

    before do
      stub_request(:put, "#{instance_url}/api/test")
        .with(
          basic_auth: [username, password],
          headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' },
          body: payload.to_json
        )
        .to_return(status: 200, body: '{"result": "put_success"}', headers: { 'Content-Type' => 'application/json' })

      stub_request(:put, "#{instance_url}/katello/api/test")
        .with(
          basic_auth: [username, password],
          headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' },
          body: payload.to_json
        )
        .to_return(status: 200, body: '{"result": "katello_put_success"}', headers: { 'Content-Type' => 'application/json' })
    end

    it 'performs a PUT request with payload to the API endpoint' do
      result = api.put('/test', payload)
      expect(result).to eq({ 'result' => 'put_success' })
    end

    it 'performs a PUT request with payload to the Katello API endpoint when katello: true' do
      result = api.put('/test', payload, katello: true)
      expect(result).to eq({ 'result' => 'katello_put_success' })
    end
  end

  describe '#delete' do
    before do
      stub_request(:delete, "#{instance_url}/api/test")
        .with(
          basic_auth: [username, password],
          headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        )
        .to_return(status: 200, body: '{"result": "delete_success"}', headers: { 'Content-Type' => 'application/json' })
    end

    it 'performs a DELETE request to the API endpoint' do
      result = api.delete('/test')
      expect(result).to eq({ 'result' => 'delete_success' })
    end
  end

  describe '#request' do
    let(:payload) { { 'data' => 'custom' } }

    before do
      stub_request(:patch, "#{instance_url}/custom/path")
        .with(
          basic_auth: [username, password],
          headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' },
          body: payload.to_json
        )
        .to_return(status: 200, body: '{"result": "custom_success"}', headers: { 'Content-Type' => 'application/json' })
    end

    it 'performs a custom request method with payload to the given URL' do
      result = api.request(:patch, '/custom/path', payload: payload)
      expect(result).to eq({ 'result' => 'custom_success' })
    end
  end
end
