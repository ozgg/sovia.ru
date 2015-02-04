class Deed < ActiveRecord::Base
  belongs_to :user
  belongs_to :goal

  validates_presence_of :user, :name

  def goal_postfix
    if goal
      I18n.t('deeds.form.to_accomplish') + " #{goal.name}"
    end
  end

  def previous_entry
    Deed.where(user_id: user_id).where("id < #{id}").order('id desc').first
  end

  def next_entry
    Deed.where(user_id: user_id).where("id > #{id}").order('id asc').first
  end
end
