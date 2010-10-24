sinatra_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift(sinatra_root) unless $LOAD_PATH.include?(sinatra_root)

require 'application'
require 'rspec'
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end