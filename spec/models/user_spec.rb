require 'spec_helper'

describe User do
  it "is valid with default attributes"
  it "is invalid without login"
  it "converts login to lowercase before validation"
  it "converts email to lowercase before validation"
  it "has unique login"
  it "has unique email"
end