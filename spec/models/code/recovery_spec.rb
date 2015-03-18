require 'rails_helper'

describe Code::Recovery, type: :model do
  it "adds user's email to payload before saving" do
    code = create(:password_recovery)
    expect(code.payload).to eq(code.user.email)
  end
end
