#!/bin/env ruby
require 'active_support/inflector'
require 'yaml'
require 'erb'

APP_ROOT = File.join(File.dirname(__FILE__),'..','..') # HELPER

scheme_description_file = File.join(APP_ROOT,'config', ARGV[0])
raise "Can't find scheme description file #{scheme_description_file}" unless File.exists?(scheme_description_file)

scheme_description = YAML.load_file(scheme_description_file)

class_name = (ARGV[0][/(scheme_description_)*(\w+).yml/,2]).pluralize.camelize
table_name = class_name.tableize

File.open(File.join(File.dirname(__FILE__),'create_migration.erb'),'r') do |f|
  erb = ERB.new( f.read )
  timestamp = Time.now.strftime('%Y%m%d%H%M%S') # HELPER
  File.open(File.join(APP_ROOT,'db','migrate',timestamp + "_create_#{table_name}.rb"), 'w') do |e|
    e.write erb.result(binding)
  end
end
