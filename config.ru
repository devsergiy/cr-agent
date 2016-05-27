# Load path and gems/bundler
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require "bundler"
Bundler.require

# Local config
require "find"

Find.find(File.join(Dir.pwd, 'lib')) do |f|
  require f unless f.match(/\/\..+$/) || File.directory?(f)
end

# Load app
require "cr_agent"
run CrAgent
