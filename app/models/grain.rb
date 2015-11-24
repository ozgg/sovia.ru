class Grain < ActiveRecord::Base
  include HasOwner
  include HasNameWithSlug
  include HasLocation

  belongs_to :user
  belongs_to :pattern
  has_many :dream_grains, dependent: :destroy
  has_many :dreams, through: :dream_grains

  enum category: [:person, :place, :item, :event, :action, :creature]

  validates_presence_of :user_id
  validates_uniqueness_of :slug, scope: [:user_id]

  mount_uploader :image, ImageUploader

  # Convert string of comma-separated grain names to array of grains
  #
  # @param [String] names
  # @param [User] user
  # @return [Array<Grain>]
  def self.string_to_array(names, user)
    list = names.split(',').select { |name| !name.blank? }.map do |name|
      self.match_or_create_by_name(name.squish, user)
    end
    list.uniq
  end

  # Find grain by name
  #
  # @param [String] name
  # @param [User] user
  # @return [Grain|nil]
  def self.match_by_name(name, user)
    find_by user: user, slug: Canonizer.canonize(name)
  end

  # Find grain by name or raise exception if it is not found
  #
  # @param [String] name
  # @param [User] user
  # @return [Grain]
  def self.match_by_name!(name, user)
    result = match_by_name name, user
    raise ActiveRecord::RecordNotFound if result.nil?
    result
  end

  # Find or create grain (with referenced) pattern by grain name
  #
  # Grain name may or may not include referenced pattern name ("foo", "(foo)", "foo(bar)")
  #
  # @param [String] long_name
  # @param [User] user
  # @return [Grain]
  def self.match_or_create_by_name(long_name, user)
    grain_name, pattern_name = self.extract_names long_name
    grain = self.match_by_name grain_name, user
    grain || self.create_pair(user, grain_name, pattern_name)
  end

  # Extract grain and pattern names from long name
  #
  # Grain can refer to pattern or be hidden:
  # "grain" — Grain "grain" references to pattern "grain"
  # "grain (pattern)" — Grain "grain" references to pattern "pattern"
  # "(grain)" — Single grain "grain" (has nil as pattern_id)
  # "grain ()" — Single grain "grain" (just another form)
  #
  # @param [String] long_name
  # @return [Array]
  def self.extract_names(long_name)
    matches = long_name.squish.scan(/\A(?:\(\s*([^)]+)\s*\)|([^(]+)\s*(?:\(\s*(.*)\s*\))?)\z/)[0]
    matches.nil? ? [long_name, long_name] : pair_from_matches(matches)
  end

  def pattern_name
    if pattern.is_a? Pattern
      pattern.name
    else
      ''
    end
  end

  protected

  # Create grain/pattern pair and return created grain
  #
  # Creates grain with references pattern or without pattern, if pattern name is nil
  #
  # @param [User] user
  # @param [String] grain_name
  # @param [String|nil] pattern_name
  # @return [Grain]
  def self.create_pair(user, grain_name, pattern_name)
    grain   = self.create(user: user, name: grain_name)
    pattern = pattern_name.nil? ? nil : Pattern.match_or_create_by_name(pattern_name)
    grain.update pattern: pattern
    grain
  end

  # Get grain/pattern name pair by result of match
  #
  # There can be following matches:
  # ['a', nil, nil] — initial string was "(a)": single grain "a"
  # [nil, 'b', nil] — initial string was "b": grain "b" with pattern "b"
  # [nil, 'b', '']  — initial string was "b()": single grain "b"
  # [nil, 'b', 'c'] — initial string was "b(c)": grain "b" with pattern "c"
  #
  # @param [Array] matches
  # @return [Array]
  def self.pair_from_matches(matches)
    if matches[0].nil?
      [matches[1].to_s.squish, identify_pattern_name(matches[2], matches[1])]
    else
      [matches[0].to_s.squish, nil]
    end
  end

  # Identify pattern name by value from match and name of referenced grain
  #
  # Returns grain name for nil as pattern name (link was not provided and was not restricted)
  # Returns nil for blank name (link was restricted)
  # Returns squished name from match for other strings (link was provided)
  #
  # @param [String|nil] value_from_match
  # @param [String] grain_name
  # @return [String|nil]
  def self.identify_pattern_name(value_from_match, grain_name)
    if value_from_match.nil?
      grain_name.to_s.squish
    else
      value_from_match.blank? ? nil : value_from_match.squish
    end
  end
end
