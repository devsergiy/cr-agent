require_relative "spec_helper"
require 'json/ext'

RSpec.shared_examples 'saves token' do
  it 'saves token' do
    expect(File.file?(token_path)).to be true
    expect(File.open(token_path, 'r') { |f| f.read }.strip).to eq(token)
  end
end


describe Agent do
  subject { described_class.new }

  before do
    stub_const('Config::BASE_PATH', './spec/dummy/config')

    allow(Agent).to receive(:faraday_connection).and_return(faraday_mock)
  end

  after { FileUtils.rm(token_path) }

  let(:token_path) { './spec/dummy/config/token' }
  let(:token)      { 'mytkn' }

  let(:response_body) { { access_token: token }.to_json }
  let(:faraday_mock) do
    Faraday.new do |builder|
      builder.adapter :test, request_stubs
    end
  end

  context '#register_to_monitor' do
    before { subject.register_to_monitor }

    let(:request_body) { { instance_id: 'unagi' }.to_json }
    let(:request_stubs) do
      Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post('/api/instances') do |env|
          requestOk =
            env.body == request_body &&
            env.request_headers["Content-Type"] == "application/json" &&
            env.request_headers["Api-Key"] == "my_api_key"

          [ requestOk ? 200 : 401, {}, response_body ]
        end
      end
    end

    include_examples 'saves token'
  end

  context '#submit_info' do
    before do
     allow(SysInfo).to receive(:collect).and_return({ some: 'system_info' })
     File.open(token_path, 'w') { |f| f.write(initial_token) }

     subject.submit_info
    end

    let(:initial_token) { 'init_token' }
    let(:token)         { 'new_token' }

    let(:request_body) { { some: 'system_info' }.to_json }
    let(:request_stubs) do
      Faraday::Adapter::Test::Stubs.new do |stub|
        stub.put('/api/instances/unagi') do |env|
          requestOk =
            env.body == request_body &&
            env.request_headers["Content-Type"] == "application/json" &&
            env.request_headers["Api-Key"] == "my_api_key" &&
            env.request_headers["Token"] == initial_token

          [ requestOk ? 200 : 401, {}, response_body ]
        end
      end
    end

    include_examples 'saves token'
  end
end
