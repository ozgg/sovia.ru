class Pattern < ActiveRecord::Base
  include HasLanguage

  before_validation :prepare_code!

  validates_presence_of :name, :code
  validates_uniqueness_of :code, scope: [:language_id]

  def prepare_code!
    lowered   = self.name.mb_chars.downcase.to_s.strip
    stripped  = lowered.gsub(/[^a-zа-я0-9ё]/, '')
    self.code = stripped.blank? ? nil : stripped
  end
end
