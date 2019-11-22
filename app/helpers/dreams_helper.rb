# frozen_string_literal: true

# Helper methods for dreams component
module DreamsHelper
  # @param [SleepPlace] entity
  # @param [String] text
  def my_sleep_place_link(entity, text = entity.name)
    link_to(text, my_sleep_place_path(id: entity.id))
  end

  # @param [Dream] entity
  # @param [String] text
  # @param [Hash] options
  def admin_dream_link(entity, text = entity.title!, options = {})
    link_to(text, admin_dream_path(id: entity.id), options)
  end

  # @param [Filler] entity
  # @param [String] text
  # @param [Hash] options
  def admin_filler_link(entity, text = entity.title!, options = {})
    link_to(text, admin_filler_path(id: entity.id), options)
  end

  # @param [Dream] entity
  # @param [String] text
  # @param [Hash] options
  def my_dream_link(entity, text = entity.title!, options = {})
    link_to(text, my_dream_path(id: entity.id), options)
  end

  # @param [Dream] entity
  # @param [String] text
  # @param [Hash] options
  def dream_link(entity, text = entity.title!, options = {})
    link_to(text, dream_path(id: entity.id), options)
  end

  # @param [Dream] entity
  def dream_privacy(entity)
    t("activerecord.attributes.dream.privacies.#{entity.privacy}")
  end

  def bots_for_select
    list = [[t(:not_selected), '']]
    list + User.bots(1).order('screen_name asc').map do |bot|
      gender_key = bot.data.dig('profile', 'gender')
      gender = UserProfileHandler::GENDERS[gender_key.blank? ? nil : gender_key.to_i]
      ["#{bot.profile_name} (#{gender})", bot.id]
    end
  end
end
