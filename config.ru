require 'sinatra/base'
require './helpers/application_helper.rb'
require './helpers/valid_string_helper.rb'
require './controllers/application_controller'
require './controllers/disc_jockey_controller'

map('/') { run DiscJockeyController }
