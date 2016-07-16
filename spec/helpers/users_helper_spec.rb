require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  describe '#user_link' do
    context 'when user is anonymous' do
      it 'renders text "Анонимно"' do
        expect(subject.user_link(nil)).to eq(I18n.t(:anonymous))
      end
    end

    context 'when user is native' do
      it 'renders link to profile with class "native"' do
        user     = create :user
        expected = link_to user.screen_name, user_profile_path(slug: user.slug), class: 'profile native'
        expect(subject.user_link(user)).to eq(expected)
      end
    end

    context 'when user is external' do
      it 'renders link to profile with network name as class' do
        user     = create :user, network: :vkontakte, slug: 'id1'
        expected = link_to user.screen_name, user_profile_path(slug: user.long_slug), class: 'profile vkontakte'
        expect(subject.user_link(user)).to eq(expected)
      end
    end

    context 'when user is deleted' do
      it 'renders text "Анонимно"' do
        user = create :user, deleted: true
        expect(subject.user_link(user)).to eq(I18n.t(:anonymous))
      end
    end
  end
end
