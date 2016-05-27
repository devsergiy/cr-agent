require_relative "spec_helper"
require 'fileutils'

describe Config do
  subject { Config.new }

  let(:token_path) { './spec/dummy/config/token' }

  before do
    stub_const('Config::BASE_PATH', './spec/dummy/config')
  end

  context '#initialize' do
    context 'reads config' do
      it 'reads api key' do
        expect(subject.config.api_key).to eq('my_api_key')
      end

      it 'reads monitor url' do
        expect(subject.config.monitor_url).to eq('http://127.0.0.1:3000')
      end
    end

    context 'no config provided' do
      before do
        stub_const('Config::BASE_PATH', 'not_exist')
      end

      it 'raises exception' do
        expect { subject }.to raise_error('No config provided')
      end
    end

    context 'token present' do
      let(:token) { 'my_token' }

      before { File.open(token_path, 'w') { |f| f.write(token) } }
      after  { FileUtils.rm(token_path) }

      it 'reads token' do
        expect(subject.token).to eq(token)
      end
    end

    context 'token absent' do
      it 'leave token empty' do
        expect(subject.token).to be_nil
      end
    end

    it 'retrieves id' do
      expect(subject.instance_id).to eq('unagi')
    end
  end

  context '#dump_token' do
    before { subject.token = token }
    after  { FileUtils.rm(token_path) }

    let(:token) { 'sample_token' }

    it 'dumps token to file' do
      subject.dump_token

      expect(File.open(token_path, 'r') { |f| f.read }.strip).to eq(token)
    end
  end

  context '#env' do
    it 'returns env' do
      expect(subject.env).to eq('test')
    end
  end
end
