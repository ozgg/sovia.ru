require 'rails_helper'

RSpec.describe My::QuestionsController, type: :controller, focus: true do
  let(:user) { create :user }
  let(:entity) { create :question, user: user }

  it_behaves_like 'list_for_owner'
end
