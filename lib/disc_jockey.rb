$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require 'disc_jockey/models'

module DiscJockey
  VERSION = '0.1.0'
end