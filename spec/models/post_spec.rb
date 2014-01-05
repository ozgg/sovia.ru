require 'spec_helper'

describe Post do
  let(:post) { Post.new }

  it "is invalid with empty body" do
    post.body = ' '
    post.valid?
    expect(post.errors).to have_key(:body)
  end

  it "is invalid without allowed privacy" do
    post.privacy = 42
    post.valid?
    expect(post.errors).to have_key(:privacy)
  end

  context "dream" do
    let(:dream) { build(:dream) }

    it "is valid with valid attributes" do
      expect(dream).to be_valid
    end
  end
end
