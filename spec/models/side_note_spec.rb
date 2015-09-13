require 'rails_helper'

RSpec.describe SideNote, type: :model do
  it_behaves_like 'has_owner'
  it_behaves_like 'has_trace'
  it_behaves_like 'required_user'

  describe 'validation' do
    it 'passes with valid attributes' do
      expect(build :side_note).to be_valid
    end

    it 'fails without title' do
      expect(build :side_note, title: ' ').not_to be_valid
    end

    it 'fails without link' do
      expect(build :side_note, link: ' ').not_to be_valid
    end
  end
end
