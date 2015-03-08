require 'rails_helper'

RSpec.describe Post, type: :model do
  context "validating", wip: true do
    let(:language) { create :russian_language }
    let(:user)     { create :user }

    it "is invalid without user" do
      post = Post.new language: language, title: 'test post', body: 'some text'
      expect(post).not_to be_valid
    end

    it "is invalid without language" do
      post = Post.new user: user, title: 'test post', body: 'some text'
      expect(post).not_to be_valid
    end

    it "is invalid with blank title" do
      post = Post.new user: user, language: language, title: ' ', body: 'some text'
      expect(post).not_to be_valid
    end

    it "is invalid with blank body" do
      post = Post.new user: user, language: language, title: 'test post', body: ' '
      expect(post).not_to be_valid
    end

    it "is valid with valid attributes" do
      post = build :post
      expect(post).to be_valid
    end
  end
end
