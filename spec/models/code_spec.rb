require 'spec_helper'

describe Code do
  let(:code) { build(:code) }

  it "is valid with valid parameters" do
    expect(code).to be_valid
  end

  it "is invalid without code_type" do
    code.code_type = nil
    expect(code).not_to be_valid
  end

  it "is invalid with unknown code_type" do
    code.code_type = 42
    code.valid?
    expect(code.errors).to have_key(:code_type)
  end

  it "is invalid without body" do
    code.body = ' '
    expect(code).not_to be_valid
  end

  it "has unique body" do
    code.save
    another_code = build(:code, body: code.body)
    expect(another_code).not_to be_valid
  end
end