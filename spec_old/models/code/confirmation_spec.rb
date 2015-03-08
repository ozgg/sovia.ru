describe Code::Confirmation do
  it "adds user's email to payload before saving" do
    code = create(:email_confirmation)
    expect(code.payload).to eq(code.user.email)
  end
end
