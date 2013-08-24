#!/bin/env ruby
require 'active_support'
require 'yaml'
require 'erb'

APP_ROOT = File.join(File.dirname(__FILE__),'..','..') # HELPER

# FIXME: make a loop for all scheme_description*.yml files
# or: generate migration file from script arguments

scheme_description_file = File.join(APP_ROOT,'config', ARGV[0])
raise "Can't find scheme description file #{scheme_description_file}" unless File.exists?(scheme_description_file)

scheme_description = YAML.load_file(scheme_description_file)

=begin
class String
  def camelize
    self.split(/[^a-z0-9]/i).map{|w| w.capitalize}.join
  end
end
=end 

# FIXME: This below doesn't work

class_name = (ARGV[0][/(scheme_description_)*(\w+).yml/,2]).camelize
table_name = class_name.tableize

File.open(File.join(File.dirname(__FILE__),'create_migration.erb'),'r') do |f|
  erb = ERB.new( f.read )
  timestamp = Time.now.strftime('%Y%m%d%H%M%S') # HELPER
  File.open(File.join(APP_ROOT,'db','migrate',timestamp + '_create_#{table_name}.rb'), 'w') do |e|
    e.write erb.result(binding)
  end
end
