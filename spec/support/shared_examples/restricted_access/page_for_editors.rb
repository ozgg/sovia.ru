require 'rails_helper'

RSpec.shared_examples_for 'page_for_editors' do
  it 'requires editor roles' do
    expect(subject).to have_received(:require_role).with(:chief_editor, :editor)
  end
end
