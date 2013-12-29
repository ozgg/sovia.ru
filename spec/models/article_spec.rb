require 'spec_helper'

describe Article do
  before(:each) { @article = build(:article) }

  it "is valid with valid parameters" do
    expect(@article).to be_valid
  end

  it "is invalid without user" do
    @article.user = nil
    expect(@article).not_to be_valid
  end

  it "is invalid without title" do
    @article.title = ' '
    expect(@article).not_to be_valid
  end

  it "is invalid without body" do
    @article.body = ' '
    expect(@article).not_to be_valid
  end
end
