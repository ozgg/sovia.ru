class AddUserToAnswers < ActiveRecord::Migration
  def change
    add_reference :answers, :user, index: true

    Answer.all.each { |answer| answer.update! user: answer.owner }
  end
end
