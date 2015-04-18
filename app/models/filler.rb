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

  def apply
    @applied = false
    last_question = Question.last
    if last_question.nil? || (Time.new - last_question.created_at > 7200)
      create_question
      @applied = true
    end
  end

  def applied?
    !@applied.blank?
  end

  protected

  def create_question
    user = User.random_bot(gender)
    Question.create!(language: self.language, user: user, body: self.body[0..499]) if user
  end
end
