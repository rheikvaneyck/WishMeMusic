class Wish < ActiveRecord::Base
  has_one :event
  belongs_to :users
end