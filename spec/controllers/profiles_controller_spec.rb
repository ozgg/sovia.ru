require 'rails_helper'

RSpec.describe ProfilesController, type: :controller, wip: true do
  let(:password) { 'secret' }
  let(:user) { create :confirmed_user, password: password, password_confirmation: password }

  describe 'new' do
    before(:each) { get :new }

    context 'when user is logged in' do
      before(:each) { allow(controller).to receive(:current_user).and_return(user) }

      it 'redirects to profile path' do
        expect(response).to redirect_to(profile_path)
      end
    end

    context 'when user is not logged in' do
      before(:each) { allow(controller).to receive(:current_user).and_return(nil) }

      it 'renders view "new"' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'create' do
    let(:user_parameters) { { screen_name: 'new_user', password: '1', password_confirmation: '1' } }
    let(:action) { -> { post :create, user: user_parameters } }

    context 'when user is logged in' do
      before(:each) { allow(controller).to receive(:current_user).and_return(user) }

      it 'does not add user to database' do
        expect(action).not_to change(User, :count)
      end

      it 'redirects to profile path' do
        action.call
        expect(response).to redirect_to(profile_path)
      end
    end

    context 'when user is not logged in' do
      before(:each) { allow(controller).to receive(:current_user).and_return(nil) }

      context 'when user is human' do
        it 'adds user to database' do
          expect(action).to change(User, :count).by(1)
        end

        it 'creates new token' do
          expect(action).to change(Token, :count).by(1)
        end

        it 'sets cookie with new token' do
          action.call
          expect(response.cookie['token']).to eq(Token.last.cookie_pair)
        end

        it 'redirects to profile path' do
          action.call
          expect(response).to redirect_to(profile_path)
        end
      end

      context 'when parameters are invalid' do
        let(:action) { -> { post :create, user: { screen_name: '?' } } }

        it 'does not add user to database' do
          expect(action).not_to change(User, :count)
        end

        it 'renders view "new"' do
          action.call
          expect(response).to render_template(:new)
        end
      end

      context 'when user is bot' do
        let(:action) { -> { post :create, agree: 1, user: user_parameters } }

        it 'does not add user to database' do
          expect(action).not_to change(User, :count)
        end

        it 'redirects to root path' do
          action.call
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe 'show' do
    before(:each) { get :show }

    context 'when user is logged in' do
      before(:each) { allow(controller).to receive(:current_user).and_return(user) }

      it 'renders view "show"' do
        expect(response).to render(:show)
      end
    end

    context 'when user is not logged in' do
      before(:each) { allow(controller).to receive(:current_user).and_return(nil) }

      it 'redirects to login path' do
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'edit' do
    before(:each) { get :edit }

    context 'when user is logged in' do
      before(:each) { allow(controller).to receive(:current_user).and_return(user) }

      it 'renders view "edit"' do
        expect(response).to render_template(:edit)
      end
    end

    context 'when user is not logged in' do
      before(:each) { allow(controller).to receive(:current_user).and_return(nil) }

      it 'redirects to login path' do
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'update' do
    let(:action) { -> { patch :update, user: { name: 'Random Guy' } } }

    context 'when user is logged in' do
      before(:each) { allow(controller).to receive(:current_user).and_return(user) }

      it 'calls #update for user' do
        expect(user).to receive(:update).with(name: 'Random Guy')
        action.call
      end

      it 'redirects to profile path' do
        action.call
        expect(response).to redirect_to(profile_path)
      end

      context 'when user changes password' do
        let(:new_data) { { password: '1', password_confirmation: '1' } }

        context 'with valid current password' do
          let(:action) { -> { patch :update, password: password, user: new_data } }

          it 'updates password for user' do
            expect(action).to change(user, :password_digest)
          end
        end

        context 'with invalid current password' do
          let(:action) { -> { patch :update, password: 'wrong', user: new_data } }

          it 'leaves password digest intact' do
            expect(action).not_to change(user, :password_digest)
          end
        end
      end

      context 'when user changes email' do
        let(:new_data) { { email: 'user@example.org' } }

        context 'with valid password' do
          let(:action) { -> { patch :update, password: password, user: new_data } }

          it 'changes email' do
            expect(action).to change(user, :email)
          end

          it 'sets email_confirmed to false' do
            action.call
            user.reload
            expect(user).not_to be_email_confirmed
          end
        end

        context 'with invalid password' do
          let(:action) { -> { patch :update, password: 'wrong', user: new_data } }
          it 'leaves email intact' do
            expect(action).not_to change(user, :email)
          end
        end
      end
    end

    context 'when user is not logged in' do
      before(:each) { allow(controller).to receive(:current_user).and_return(nil) }

      it 'redirects to login path' do
        action.call
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
