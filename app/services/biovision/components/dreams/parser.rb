# frozen_string_literal: true

module Biovision
  module Components
    module Dreams
      # Dream parser
      class Parser
        LINK_PATTERN = /\[dream (?<id>\d{1,7})\](?:\((?<text>[^)]{1,64})\))?/.freeze
        NAME_PATTERN = /{(?<name>[^}]{1,30})}(?:\((?<text>[^)]{1,30})\))?/.freeze

        attr_accessor :user

        # @param [User] user
        def initialize(user = nil)
          self.user = user
        end

        # @param [String] string
        # @param [User] owner
        def parse(string, owner)
          output = string.gsub('<', '&lt;').gsub('>', '&gt;')
          output = parse_links(output)
          output = parse_names(output, user == owner) unless owner.nil?
          "<p>#{output}</p>\n"
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
            name = match[:text] || match[:name].split(/[\s-]+/).map(&:first).join

            title = show_names ? match[:name] : ''
            %(<span class="name-in-dream" title="#{title}">#{name}</span>)
          end
        end

        # @param [Dream] dream
        # @param [String] text
        # @param [Integer] fallback_id
        def dream_link(dream, text, fallback_id)
          if dream&.visible_to?(user)
            title = dream.title!
            link_text = text.blank? ? title : text
            href = dream.url
            %(<cite><a href="#{href}" title="#{title}">#{link_text}</a></cite>)
          else
            %(<span class="not-found">[dream #{fallback_id}]</span>)
          end
        end
      end
    end
  end
end
