require 'rails_helper'

RSpec.describe Admin::TagsController, type: :controller do
  let!(:entity) { create :tag }

  it_behaves_like 'list_for_editors'
end
