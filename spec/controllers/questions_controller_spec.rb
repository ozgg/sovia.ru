require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create :unconfirmed_user }
  let(:moderator) { create :moderator }
  let!(:question) { create :question }
  let(:question_params) { { question: { body: 'Huh?' } } }

  before :each do
    allow(controller).to receive(:allow_authorized_only)
    allow(controller).to receive(:track_agent)
    allow(controller).to receive(:demand_role)
  end

  shared_examples 'tracking' do
    it 'tracks user agent' do
      expect(controller).to have_received(:track_agent)
    end
  end

  shared_examples 'validating authorization' do
    it 'calls :allow_authorized_only' do
      expect(controller).to have_received(:allow_authorized_only)
    end
  end

  shared_examples 'checking moderator' do
    it 'demands moderator role' do
      expect(controller).to have_received(:demand_role).with(:moderator)
    end
  end

  shared_examples 'question setter' do
    it 'assigns question to @question' do
      expect(assigns[:question]).to eq(question)
    end
  end

  describe 'get index' do
    before(:each) { get :index }

    it 'assigns @questions that includes question' do
      expect(assigns[:questions]).to include(question)
    end

    it_should_behave_like 'tracking'
  end

  describe 'get new' do
    before(:each) { get :new }

    it 'assigns new Question to question' do
      expect(assigns[:question]).to be_a_new(Question)
    end

    it_should_behave_like 'tracking'
    it_should_behave_like 'validating authorization'
  end

  describe 'post create' do
    before(:each) { session[:user_id] = user.id }

    context 'tracking and redirect' do
      before(:each) { post :create, question_params }

      it 'redirects to created question' do
        expect(response).to redirect_to(Question.last)
      end

      it_should_behave_like 'tracking'
      it_should_behave_like 'validating authorization'
    end

    context 'database change' do
      it 'adds question to database' do
        expect { post :create, question_params }.to change(Question, :count).by(1)
      end
    end
  end

  describe 'get show' do
    before(:each) { get :show, id: question.id }

    it_should_behave_like 'question setter'
    it_should_behave_like 'tracking'
  end

  describe 'get edit' do
    before :each do
      session[:user_id] = moderator.id
      get :edit, id: question.id
    end

  end

  describe 'patch update' do
    before :each do
      session[:user_id] = moderator.id
      patch :update, { id: question.id }.merge(question_params)
    end

    it 'redirects to question' do
      expect(response).to redirect_to(question)
    end

    it_should_behave_like 'question setter'
    it_should_behave_like 'tracking'
    it_should_behave_like 'checking moderator'
  end

  describe 'delete destroy' do
    before(:each) { session[:user_id] = moderator.id }
    let(:action) { -> { delete :destroy, id: question.id } }

    context 'validating and setting' do
      before(:each) { action.call }

      it 'redirects to questions list' do
        expect(response).to redirect_to(questions_path)
      end

      it_should_behave_like 'question setter'
      it_should_behave_like 'tracking'
      it_should_behave_like 'checking moderator'
    end

    context 'changing database' do
      it 'deletes question from database' do
        expect(action).to change(Question, :count).by(-1)
      end
    end
  end
end
