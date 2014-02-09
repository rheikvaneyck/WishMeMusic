require 'sinatra/base'
require File.expand_path '../helpers/application_helper.rb', __FILE__
require File.expand_path '../helpers/valid_string_helper.rb', __FILE__
require File.expand_path '../helpers/collection_helper.rb', __FILE__
require File.expand_path '../controllers/application_controller', __FILE__
require File.expand_path '../controllers/disc_jockey_controller', __FILE__

run DiscJockeyController 
