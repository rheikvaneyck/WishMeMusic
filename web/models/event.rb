class Event < ActiveRecord::Base
  belongs_to :wishes
  belongs_to :users
end