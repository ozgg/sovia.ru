# frozen_string_literal: true

module Biovision
  module Components
    # Component for handling dreams
    class DreamsComponent < BaseComponent
      LINK_PATTERN = /\[dream (?<id>\d{1,7})\](?:\((?<text>[^)]{1,64})\))?/.freeze
      NAME_PATTERN = /{(?<name>[^}]{1,30})}(?:\((?<text>[^)]{1,30})\))?/.freeze
      REQUEST_COUNTER = 'interpretation_requests'

      def self.price_map
        { 1 => 500, 3 => 1000, 5 => 1500, 10 => 2000 }
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
        owner   = dream.user
        strings = dream.body.split("\n").map(&:squish).reject(&:blank?)
        strings.map { |s| parse(s, owner) }.join
      end

      # @param [Dream] dream
      def dream_preview(dream)
        words = parsed_dream(dream).gsub(%r{</?[^>]*>}, ' ').split(/\s+/)
        ellipsis = words.count > 50 ? '…' : ''
        "<p>#{words.first(50).join(' ')}#{ellipsis}</p>"
      end

      # @param [Dream] dream
      # @param [String] text
      # @param [Integer] fallback_id
      def dream_link(dream, text, fallback_id)
        if dream&.visible_to?(user)
          title     = dream.title!
          link_text = text.blank? ? title : text
          href      = "/dreams/#{dream.id}"
          %(<cite><a href="#{href}" title="#{title}">#{link_text}</a></cite>)
        else
          %(<span class="not-found">[dream #{fallback_id}]</span>)
        end
      end

      # Parse fragments like [dream 123](link text)
      #
      # @param [String] string
      # @return [String]
      def parse_links(string)
        pattern = LINK_PATTERN
        string.gsub(pattern) do |chunk|
          match = pattern.match(chunk)
          dream = Dream.visible.find_by(id: match[:id])
          dream_link(dream, match[:text], match[:id])
        end
      end

      # Parse fragments like {Real Name}(text)
      #
      # @param [String] string
      # @param [TrueClass|FalseClass] show_names
      # @return [String]
      def parse_names(string, show_names)
        pattern = NAME_PATTERN
        string.gsub(pattern) do |chunk|
          match = pattern.match chunk
          name  = match[:text] || match[:name].split(/[\s-]+/).map(&:first).join

          title = show_names ? match[:name] : ''
          %(<span class="name-in-dream" title="#{title}">#{name}</span>)
        end
      end

      # @param [String] string
      # @param [User] owner
      def parse(string, owner)
        output = string.gsub('<', '&lt;').gsub('>', '&gt;')
        output = parse_links(output)
        output = parse_names(output, user == owner) unless owner.nil?
        "<p>#{output}</p>\n"
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

      protected

      # @param [Hash] data
      # @return [Hash]
      def normalize_settings(data)
        result = {}
        numbers = %w[filler_timeout place_limit]
        numbers.each { |f| result[f] = data[f].to_i }

        result
      end

      # @param [Dream] dream
      def create_interpretation_request(dream)
        interpretation = Interpretation.new(dream: dream, user: @user)
        if interpretation.save
          decrement_request_count
          InterpretationMailer.new_request(interpretation.id)
          Interpretation::STATE_CREATED
        else
          Interpretation::STATE_ERROR
        end
      end

      def decrement_request_count
        @user.data['sovia'] ||= {}
        @user.data['sovia'][REQUEST_COUNTER] = request_count - 1
        @user.save
      end
    end
  end
end
