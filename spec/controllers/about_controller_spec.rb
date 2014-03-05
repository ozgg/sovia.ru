require 'spec_helper'

describe AboutController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'features'" do
    it "returns http success" do
      get 'features'
      response.should be_success
    end
  end

  describe "GET 'changelog'" do
    it "returns http success" do
      get 'changelog'
      response.should be_success
    end
  end

end
