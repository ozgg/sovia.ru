require 'spec_helper'

describe SessionsController do

  let(:user) { create(:user) }

  context 'when user is not logged in' do
    before(:each) { session[:user_id] = nil }

    describe 'get new' do
      it 'renders view with form' do
        get :new
        expect(response).to render_template('sessions/new')
      end
    end

    describe 'delete destroy' do
      it 'redirects to root page' do
        delete :destroy
        expect(response).to redirect_to(root_path)
      end

      it 'adds flash message "Вы вышли"' do
        delete :destroy
        expect(flash[:message]).to eq(I18n.t('session.not_logged_in'))
      end
    end
  end

  context 'Successful login' do
    before(:each) { post :create, login: user.login, password: 'secret' }

    it 'creates session with user id' do
      expect(session[:user_id]).to eq(user.id)
    end

    it 'redirects to root page' do
      expect(response).to redirect_to(root_path)
    end

    it 'adds flash message "Вы вошли"' do
      expect(flash[:message]).to eq(I18n.t('session.logged_in_successfully'))
    end
  end

  context 'Unsuccessful login' do
    before(:each) { post :create, login: user.login, password: 'incorrect' }

    it 'redirects to login page' do
      expect(response).to redirect_to(login_path)
    end

    it 'adds flash message "Неправильный пароль"' do
      expect(flash[:message]).to eq(I18n.t('session.invalid_credentials'))
    end
  end

  context 'when user is logged in' do
    before(:each) { session[:user_id] = user.id }

    describe 'get new' do
      before :each do
        get :new
      end

      it 'redirects to root page' do
        expect(response).to redirect_to(root_path)
      end

      it 'adds flash message "Вы уже вошли"' do
        expect(flash[:message]).to eq(I18n.t('session.already_logged_in'))
      end
    end

    describe 'post create' do
      before(:each) { post :create }

      it 'redirects to root page' do
        expect(response).to redirect_to(root_path)
      end

      it 'adds flash message "Вы уже вошли"' do
        expect(flash[:message]).to eq(I18n.t('session.already_logged_in'))
      end
    end

    describe 'delete destroy' do
      before(:each) { delete :destroy }

      it 'deletes user id from session' do
        expect(session[:user_id]).to be_nil
      end

      it 'redirects to root page' do
        expect(response).to redirect_to(root_path)
      end

      it 'adds flash message "Вы вышли"' do
        expect(flash[:message]).to eq(I18n.t('session.logged_out'))
      end
    end
  end
end
