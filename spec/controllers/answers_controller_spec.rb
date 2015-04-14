require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create :question }

  describe 'post create' do

    before :each do
      session[:user_id] = create(:unconfirmed_user).id
    end

    it 'adds answer to database' do
      action = -> { post :create, answer: { question_id: question.id, body: '42' } }
      expect(action).to change(Answer, :count).by(1)
    end
  end
end
