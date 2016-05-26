require 'json/ext'
require 'byebug'

class Agent
  API_PATH = '/api/instances'.freeze

  def initialize
    @cfg = Config.new
    @conn = Faraday.new(:url => @cfg.config.monitor_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def registered?
    @cfg.token != nil && @cfg.token != ''
  end

  def register_to_monitor
    puts 'register_to_monitor'

    response = @conn.post do |req|
      req.url API_PATH
      req.headers['Content-Type'] = 'application/json'
      req.headers['api_key'] = @cfg.config.api_key
      req.body = { instance_id: @cfg.instance_id }.to_json
    end
    save_token(response)
  end

  def submit_info
    puts 'submit_info'

    response = @conn.put do |req|
      req.url "#{API_PATH}/#{@cfg.instance_id}"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Token'] = @cfg.token
      req.headers['Api-Key'] = @cfg.config.api_key
      req.body = SysInfo.collect.to_json
    end
    save_token(response)
  end

  def save_token(response)
    return unless response.success?

    @cfg.token = JSON.parse(response.body)['access_token']
    @cfg.dump_token
  end
end
