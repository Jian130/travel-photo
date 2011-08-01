require 'spec_helper'

describe AuthenticationsController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "should be successful" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'destory'" do
    it "should be successful" do
      get 'destory'
      response.should be_success
    end
  end

end
