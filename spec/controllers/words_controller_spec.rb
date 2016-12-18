require 'rails_helper'

RSpec.describe WordsController, type: :controller do
  let!(:entity) { create :word }
  let(:required_roles) { [:chief_interpreter, :interpreter] }
  let(:valid_create_params) { { word: attributes_for(:word) } }
  let(:valid_update_params) { { id: entity.id, word: { body: 'changed' } } }
  let(:invalid_create_params) { { word: { body: ' ' } } }
  let(:invalid_update_params) { { id: entity.id, word: { body: ' ' } } }
  let(:path_after_create) { admin_word_path(entity.class.last.id) }
  let(:path_after_update) { admin_word_path(entity.id) }
  let(:path_after_destroy) { admin_words_path }

  it_behaves_like 'new_entity_with_required_roles'
  it_behaves_like 'create_entity_with_required_roles'
  it_behaves_like 'edit_lockable_entity_with_required_roles'
  it_behaves_like 'update_lockable_entity_with_required_roles'
  it_behaves_like 'destroy_lockable_entity_with_required_roles'
end
