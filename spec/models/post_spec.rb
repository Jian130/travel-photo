require 'spec_helper'

describe Post do

	before( :each ) do
		@user = User.create!(
      :email => "test@gmail.com",
      :password => "testpwd",
      :password_confirmation => "testpwd")
    @profile = @user.create_profile(:username => "test",
      :first_name => "ftest",
      :last_name => "ltest")
		@attr = { :message => "test msg" }
		
	end

  it "should create a Post" do
    @user.posts.create!( @attr )
  end

  describe "post validations" do
    
    it "should require a message" do
      no_message_post = @user.posts.new( @attr.merge(:message => "") )
      no_message_post.should_not be_valid
    end
    
    it "should have a message length <= 140" do
      long_msg = ""
      (0...141).each { long_msg = long_msg + "a" }
      long_message_post = @user.posts.new( @attr.merge(:message => long_msg) )
      long_message_post.should_not be_valid
    end
    
    it "should not mass-assign a user_id" do
      no_user_id_post = Post.new( @attr.merge(:user_id => 1) )
      no_user_id_post.should_not be_valid
    end

  end
end
