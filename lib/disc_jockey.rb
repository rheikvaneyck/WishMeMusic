$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require 'disc_jockey/models'
require 'disc_jockey/match_score'

module DiscJockey
  VERSION = '0.3.0'
end