require 'yaml'
require 'ostruct'

class Config
  BASE_PATH       = './config/'
  KEY_FILE_NAME   = 'api.key'.freeze
  TOKEN_FILE_NAME = 'token'.freeze

  attr_reader :api_key, :token

  def initialize
    @api_key = read_file(KEY_FILE_NAME)
    @token = read_file(TOKEN_FILE_NAME)
  end

  def dump_token
    File.open(CFG_FILE_PATH, 'w') { |f| f.write YAML.dump @keys.to_h }
  end

  protected

  def read_file(fname)
    File.open(BASE_PATH + fname, 'r') { |f| f.read }.strip
  end
end
