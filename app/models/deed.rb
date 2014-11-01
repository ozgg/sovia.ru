class Deed < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user, :name

  def previous_entry
    Deed.where(user_id: user_id).where("id < #{id}").order('id desc').first
  end

  def next_entry
    Deed.where(user_id: user_id).where("id > #{id}").order('id asc').first
  end
end
