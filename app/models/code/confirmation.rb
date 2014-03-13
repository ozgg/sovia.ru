class Code::Confirmation < Code
  before_save :set_email_as_payload
end
