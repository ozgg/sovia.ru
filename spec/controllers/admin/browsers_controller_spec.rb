require 'rails_helper'

RSpec.describe Admin::BrowsersController, type: :controller do
  let!(:entity) { create :browser }

  it_behaves_like 'list_for_administration'
end
