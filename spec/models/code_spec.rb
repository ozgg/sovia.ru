require 'spec_helper'

describe Code do
  let(:code) { build(:code) }

  it "is valid with valid parameters" do
    pending
    code.code_type = Code::TYPE_PASSWORD_RECOVERY
    expect(code).to be_valid
  end

  it "is invalid without code_type" do
    pending
    code.code_type = nil
    expect(code).not_to be_valid
  end

  it "is invalid with unknown code_type" do
    pending
    code.code_type = 42
    code.valid?
    expect(code.errors).to have_key(:code_type)
  end

  it "is invalid without body" do
    pending
    code.body = ' '
    expect(code).not_to be_valid
  end

  it "has unique body" do
    pending
    code.save
    another_code = build(:code, body: code.body)
    expect(another_code).not_to be_valid
  end

  it "has non-empty body on creation" do
    pending
    expect(Code.new.body).not_to be_blank
  end
end