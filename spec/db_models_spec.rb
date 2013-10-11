require 'disc_jockey/models'

include DiscJockey

describe DBManager do

  class User < ActiveRecord::Base
    has_many :wishes
    has_many :events
  end

  class Wish < ActiveRecord::Base
    has_one :event
    belongs_to :user
  end 

  before(:all) do
    @db = DBManager.new("spec/test_data")
    @users = User.all
  end

  it "should have ActiveRecord to be connected" do
    expect(ActiveRecord::Base.connected?).to be true
  end

  it "should find 4 users in test_data" do
    expect(@users.length).to be 4
  end

  it "returns a wish over a relation to user" do
    @user = @users.first
    expect(@user.wishes.nil?).to be false
  end

  it "returns a user a wish belongs to" do
    @wish = Wish.first
    expect(@wish.user.name).to eq("Johnson")
  end  
end

