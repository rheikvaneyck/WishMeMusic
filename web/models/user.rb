class User < ActiveRecord::Base
  has_many :wishes
  has_many :events
end