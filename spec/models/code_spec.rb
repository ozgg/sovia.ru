require 'rails_helper'

RSpec.describe Code, type: :model do
  let(:model) { :code }
  
  it_behaves_like 'required_user'
  it_behaves_like 'has_owner'

  describe 'new instance' do
    it 'generates code body' do
      expect(Code.new.body).not_to be_nil
    end
  end

  describe 'validation' do
    it 'fails without body' do
      entity = build model
      entity.body = ' '
      expect(entity).not_to be_valid
    end

    it 'fails for non-unique body' do
      existing = create model
      entity = build model
      entity.body = existing.body
      expect(entity).not_to be_valid
    end
  end

  describe '#recovery_for_user' do
    let(:user) { create :unconfirmed_user }
    let(:action) { -> { Code.recovery_for_user user } }

    context 'when non-activated recovery exists' do
      let!(:entity) { create :recovery_code, user: user }

      it 'returns existing code' do
        expect(action.call).to eq(entity)
      end

      it 'does not insert new code' do
        expect(action).not_to change(Code, :count)
      end
    end

    context 'when recovery does not exist' do
      it 'creates new code' do
        expect(action).to change(Code, :count)
      end

      it 'returns new code' do
        expect(action.call).to be_a(Code)
      end
    end

    it 'returns non-activated code' do
      expect(action.call).not_to be_activated
    end

    it 'sets email of user as payload' do
      expect(action.call.payload).to eq(user.email)
    end
  end

  describe '#confirmation_for_user' do
    let(:user) { create :user }
    let(:action) { -> { Code.confirmation_for_user user } }

    context 'when non-activated confirmation exists' do
      let!(:entity) { create :confirmation_code, user: user }

      it 'returns existing code' do
        expect(action.call).to eq(entity)
      end

      it 'does not insert new code' do
        expect(action).not_to change(Code, :count)
      end
    end

    context 'when confirmation does not exist' do
      it 'creates new code' do
        expect(action).to change(Code, :count)
      end

      it 'returns new code' do
        expect(action.call).to be_a(Code)
      end
    end

    it 'returns non-activated code' do
      expect(action.call).not_to be_activated
    end

    it 'sets email of user as payload' do
      expect(action.call.payload).to eq(user.email)
    end
  end
end
