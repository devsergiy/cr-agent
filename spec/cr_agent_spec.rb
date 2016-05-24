require_relative "spec_helper"
require_relative "../cr_agent.rb"

def app
  CrAgent
end

describe CrAgent do
  it "responds with a welcome message" do
    get '/'

    last_response.body.must_include 'Welcome to the Sinatra Template!'
  end
end
