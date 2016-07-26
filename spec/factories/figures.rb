FactoryGirl.define do
  factory :figure do
    post
    # image { Rack::Test::UploadedFile.new('spec/support/images/placeholder.png', 'image/png') }
  end
end
