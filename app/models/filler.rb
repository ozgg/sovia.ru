class Filler < ActiveRecord::Base
  belongs_to :language

  validates_presence_of :language, :body

  enum gender: [:female, :male]
  enum queue: [:question]

  def self.queues_for_form
    queues.keys.to_a.map { |e| [I18n.t("activerecord.attributes.filler.queues.#{e}"), e] }
  end

  def self.genders_for_form
    [[I18n.t(:empty), '']] + genders.keys.to_a.map { |e| [I18n.t("activerecord.attributes.filler.genders.#{e}"), e] }
  end
end
