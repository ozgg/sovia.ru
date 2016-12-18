require 'rails_helper'

RSpec.describe Admin::TagsController, type: :controller do
  let!(:entity) { create :tag }
  let(:required_roles) { [:chief_editor, :editor] }

  it_behaves_like 'index_entities_with_required_roles'
  # it_behaves_like 'show_entity_with_required_roles'
end
