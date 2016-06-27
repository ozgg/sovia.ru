require 'rails_helper'

RSpec.describe Agent, type: :model do
  subject { build :agent }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_unique_name'
  it_behaves_like 'required_name'

  describe '::named' do
    let(:action) { -> { Agent.named(subject.name) } }

    context 'when Agent exists' do
      before :each do
        subject.save!
      end

      it 'returns instance of Agent' do
        expect(action.call).to eq(subject)
      end

      it 'does not change database' do
        expect(action).not_to change(Agent, :count)
      end
    end

    context 'when Agent does not exist' do
      it 'returns instance of Agent' do
        expect(action.call).to be_an_instance_of(Agent)
      end

      it 'adds new Agent to database' do
        expect(action).to change(Agent, :count).by(1)
      end
    end
  end
end
