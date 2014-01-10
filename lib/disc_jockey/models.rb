# This lib containts the database model
#--
# Copyright (c) 2013 Viktor Rzesanke
# Licensed under the same terms as Ruby. No warranty is provided.

require 'active_record'
require 'uri'
require 'yaml'
require 'logger'

module DiscJockey
  class DBManager
    def initialize(config_path=File.expand_path('../../../config', __FILE__))
      if (ENV['DATABASE_URL']) then
        db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/app-dev')
        db_config = {
          :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
          :host     => db.host,
          :port     => db.port,
          :username => db.user,
          :password => db.password,
          :database => db.path[1..-1],
          :encoding => 'utf8',
          :log_dir => "log"
        }
      elsif (ENV['PRODUCTION']) then
        db_config = YAML::load(File.open(File.join(config_path,'database.yml')))['production']
        ActiveRecord::Base.logger = Logger.new(File.open(File.join(File.expand_path('../../../log', __FILE__),'database.log'), 'a'))
      else
        db_config = YAML::load(File.open(File.join(config_path,'database.yml')))['development']
        db_config['database'] = File.expand_path("../../../#{db_config['database']}", __FILE__)
        ActiveRecord::Base.logger = Logger.new(File.open(File.join(File.expand_path('../../../log', __FILE__),'database.log'), 'a'))
      end
      ActiveRecord::Base.establish_connection(db_config)
    end
  end
end