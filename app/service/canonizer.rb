class Canonizer
  def self.canonize(input)
    lowered   = input.mb_chars.downcase.to_s.strip
    canonized = lowered.gsub(/[^a-zа-я0-9ё]/, '')
    canonized.empty? ? lowered : canonized
  end

  def self.urlize(input)
    lowered = input.mb_chars.downcase.to_s.squish
    lowered.gsub(/[^a-zа-я0-9ё]/, '-').gsub(/-\z/, '')
  end
end