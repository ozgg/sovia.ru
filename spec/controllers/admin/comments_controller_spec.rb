require 'rails_helper'

RSpec.describe Admin::CommentsController, type: :controller do
  let!(:entity) { create :comment }

  it_behaves_like 'list_for_administration'
end
