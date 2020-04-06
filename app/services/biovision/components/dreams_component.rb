# frozen_string_literal: true

module Biovision
  module Components
    # Component for handling dreams
    class DreamsComponent < BaseComponent
      REQUEST_COUNTER = 'interpretation_requests'

      def self.price_map
        { 1 => 300, 3 => 750, 5 => 1200, 10 => 2000 }
      end

      def use_parameters?
        false
      end

      # @param [Dream] entity
      def visible?(entity)
        return true if entity.owned_by?(user) || entity.generally_accessible?

        entity.for_community? && user.is_a?(User)
      end

      # @param [Dream] entity
      def editable?(entity)
        return true if entity.owned_by?(user)

        administrator? && visible?(entity)
      end

      # @param [Dream] dream
      def parsed_dream(dream)
        parser = Dreams::Parser.new(user)
        # @type [User]
        owner = dream.user
        strings = dream.body.split("\n").map(&:squish).reject(&:blank?)
        strings.map { |s| parser.parse(s, owner) }.join
      end

      # @param [Dream] dream
      def dream_preview(dream)
        words = parsed_dream(dream).gsub(%r{</?[^>]*>}, ' ').split(/\s+/)
        ellipsis = words.count > 50 ? '…' : ''
        "<p>#{words.first(50).join(' ')}#{ellipsis}</p>"
      end

      def can_add_sleep_place?
        return false if user.nil?

        SleepPlace.owned_by(user).count < settings['place_limit']
      end

      # @param [Integer] dream_id
      def request_interpretation(dream_id)
        dream = Dream.owned_by(@user).find_by(id: dream_id)

        return Interpretation::STATE_NO_DREAM if dream.nil?
        return Interpretation::STATE_NO_REQUESTS if request_count < 1

        criteria = { user: @user, dream: dream }
        interpretation = Interpretation.find_by(criteria)
        if interpretation.nil?
          create_interpretation_request(dream)
        else
          Interpretation::STATE_EXISTS
        end
      end

      def request_count
        return 0 if @user.nil?

        @user.data.dig('sovia', REQUEST_COUNTER).to_i
      end

      # @param [Integer] new_value
      def request_count=(new_value)
        return if @user.nil?

        @user.data['sovia'] ||= {}
        @user.data['sovia'][REQUEST_COUNTER] = new_value.to_i
        @user.save
      end

      protected

      # @param [Hash] data
      # @return [Hash]
      def normalize_settings(data)
        result = {}
        numbers = %w[filler_timeout place_limit free_interpretations]
        numbers.each { |f| result[f] = data[f].to_i }

        result
      end

      # @param [Dream] dream
      def create_interpretation_request(dream)
        interpretation = Interpretation.new(dream: dream, user: @user)
        if interpretation.save
          self.request_count = request_count - 1
          InterpretationMailer.new_request(interpretation.id)
          Interpretation::STATE_CREATED
        else
          Interpretation::STATE_ERROR
        end
      end
    end
  end
end
