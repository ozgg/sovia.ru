class Entry::Article < Entry
  after_initialize :set_specific_fields
  validates_presence_of :user, :title

  def matching_tag(name)
    Tag::Article.match_or_create_by_name(name)
  end

  def parse_body(input)
    output = ''
    input.strip.split(/(?:\r?\n)+/).each do |s|
      if s[0] == '<'
        output += s
      else
        output += "<p>#{s}</p>"
      end
    end

    output
  end

  private

  def set_specific_fields
    self.privacy = PRIVACY_NONE
  end
end
