require 'spec_helper'

describe User do
  before(:each) { @user = build(:user, login: 'random_guy') }

  it "is valid with default attributes" do
    expect(@user).to be_valid
  end

  it 'is invalid when login does not match pattern /\A[a-z0-9_]{1,30}\z/' do
    @user.login = 'bad login'
    expect(@user).not_to be_valid
  end

  it "converts login to lowercase before validation" do
    @user.login = 'Another_GUY'
    @user.valid?
    expect(@user.login).to eq('another_guy')
  end

  it "converts email to lowercase before validation" do
    @user.email = 'NOREPLY@example.com'
    @user.valid?
    expect(@user.email).to eq('noreply@example.com')
  end

  it "has unique login" do
    @user.save
    another_user = build(:user, login: 'random_guy', email: 'noreply@example.com')
    expect(another_user).not_to be_valid
  end

  it "has unique email" do
    @user.email = 'noreply@example.com'
    @user.save
    another_user = build(:user, email: 'noreply@example.com')
    expect(another_user).not_to be_valid
  end

  it "is invalid when email does not look like email" do
    @user.email = 'www'
    expect(@user).not_to be_valid
  end
end