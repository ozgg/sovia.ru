require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  describe '#user_link' do
    context 'when user is anonymous' do
      it 'renders text "Анонимно"' do
        expect(helper.user_link(nil)).to eq(I18n.t(:anonymous))
      end
    end

    context 'when user is native' do
      it 'renders link to profile with class "native"' do
        user = create :user
        expected = link_to user.screen_name, user_profile_path(uid: user.uid), class: 'native user'
        expect(helper.user_link(user)).to eq(expected)
      end
    end

    context 'when user is external' do
      it 'renders link to profile with network name as class' do
        user = create :user, network: :vk, uid: 'id1'
        expected = link_to user.screen_name, user_profile_path(uid: user.long_uid), class: 'vk user'
        expect(helper.user_link(user)).to eq(expected)
      end
    end
  end

  describe 'comment_avatar' do
    pending
  end
end
