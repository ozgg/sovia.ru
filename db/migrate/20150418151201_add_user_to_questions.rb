class AddUserToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :user, index: true

    Question.all.each { |question| question.update! user: question.owner }
  end
end
