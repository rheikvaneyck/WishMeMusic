require 'sinatra/base'
require './helpers/application_helper.rb'
require './helpers/valid_string_helper.rb'
require './controllers/application_controller'
require './controllers/disc_jockey_controller'

map('/') { 
  logger = Logger.new('log/app.log')

  use Rack::CommonLogger, logger
  run DiscJockeyController 
}
