# encoding: UTF-8

require 'bundler'

Bundler.setup
Bundler.require

ENV["RACK_ENV"] = "test"

require "rspec"
require "byebug"

require "find"
Find.find('./lib') { |f| require f if f.match(/\.rb$/) }
