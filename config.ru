# Load path and gems/bundler
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require "bundler"
Bundler.require

# Local config
require "find"

%w{config/initializers lib}.each do |load_path|
  Find.find(File.join(Dir.pwd, load_path)) do |f|
    require f unless f.match(/\/\..+$/) || File.directory?(f)
  end
end

# Load app
require "cr_agent"
run CrAgent
