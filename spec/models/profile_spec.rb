require 'spec_helper'

describe Profile do
  before( :each ) do
    @user = User.create!(
      :email => "test@gmail.com",
      :password => "testpwd",
      :password_confirmation => "testpwd")
    @attr = { :username => "test", :first_name => "ftest", :last_name => "ltest" }
  end

  describe "creation" do

    it "should create a Profile" do
      @user.create_profile!( @attr )
    end

  end
end
