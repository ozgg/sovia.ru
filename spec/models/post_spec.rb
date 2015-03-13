require 'rails_helper'

RSpec.describe Post, type: :model do
  context "validating" do
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

  context "editable_by?" do
    let(:user) { create :user }
    let(:post) { create :post, user: user }

    it "returns true for author" do
      expect(post).to be_editable_by user
    end

    it "returns true for posts manager" do
      manager = create :posts_manager
      expect(post).to be_editable_by manager
    end

    it "returns false for anonymous user" do
      expect(post).not_to be_editable_by nil
    end

    it "returns false for another user" do
      another_user = create :user
      expect(post).not_to be_editable_by another_user
    end
  end

  context "visible_to?" do
    let(:post) { create :post }

    it "returns true for anonymous user" do
      expect(post).to be_visible_to nil
    end

    it "returns true for regular user" do
      user = create :user
      expect(post).to be_visible_to user
    end
  end

  context "locale" do
    before(:each) { I18n.default_locale = :ru }

    it "returns nil for default locale" do
      language = create :russian_language
      post = create :post, language: language
      expect(post.locale).to be_nil
    end

    it "returns code for non-default locale" do
      language = create :english_language
      post = create :post, language: language
      expect(post.locale).to eq(language.code)
    end
  end
end
