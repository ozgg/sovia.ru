require 'rails_helper'

RSpec.describe Admin::FillersController, type: :controller do
  let(:entity) { create :filler }
  let(:required_roles) { [:chief_editor, :editor] }

  it_behaves_like 'list_for_administration'
  it_behaves_like 'entity_for_administration'
end
