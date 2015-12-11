namespace :fill do
  desc 'Fill questions with bots as authors'
  task questions: :environment do
    question = Question.last
    if question.is_a?(Question) && question.created_at < Time.now - 9.hours
      filler = Filler.category(Filler.categories[:question]).first
      add_question filler unless filler.nil?
    end
  end

  desc 'Fill dreams with bots as authors'
  task dreams: :environment do
    dream = Dream.last
    if dream.is_a?(Dream) && dream.created_at < Time.now - 12.hours
      filler = Filler.category(Filler.categories[:dream]).first
      add_dream filler unless filler.nil?
    end
  end

  # Add question from given filler
  #
  # @param [Filler] filler
  # @return [Boolean]
  def add_question(filler)
    parameters = {
        created_at: Time.now - Random.rand(7200).seconds,
        user: bot(filler.numeric_gender),
        body: filler.body
    }
    filler.destroy if Question.create parameters
  end

  # Add dream from given filler
  #
  # @param [Filler] filler
  # @return [Boolean]
  def add_dream(filler)
    parameters = {
        created_at: Time.now - Random.rand(7200).seconds,
        user: bot(filler.numeric_gender),
        privacy: Dream.privacies[:generally_accessible],
        body: filler.body,
        title: filler.title,
    }
    filler.destroy if Dream.create parameters
  end

  # Get random bot of given gender
  #
  # @param [Integer] gender
  # @return [User]
  def bot(gender)
    max_offset = User.bots(1).gender(gender).count - 1
    offset     = Random.rand(max_offset)
    User.bots(1).gender(gender).offset(offset).first
  end
end
