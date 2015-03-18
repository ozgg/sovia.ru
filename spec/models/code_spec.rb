require 'rails_helper'

describe Code, type: :model do
  let(:code) { build(:code) }

  it "is invalid without body" do
    code.body = ' '
    code.valid?
    expect(code.errors).to have_key(:body)
  end

  it "has unique body" do
    another_code = create(:email_confirmation)
    code.body = another_code.body
    expect(code).not_to be_valid
  end

  it "has non-empty body on creation" do
    expect(Code.new.body).not_to be_blank
  end
end