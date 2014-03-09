class UserTag < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag

  def self.consider_increment(tag_entry)
    owner = tag_entry.entry.user
    unless owner.nil?
      intersection = self.find_or_create_by(tag: tag_entry.tag, user: owner)
      intersection.entries_count += 1
      intersection.save
    end
  end

  def self.consider_decrement(tag_entry)
    owner = tag_entry.entry.user
    unless owner.nil?
      intersection = self.find_by(tag: tag_entry.tag, user: owner)
      intersection.decrement! :entries_count unless intersection.nil?
    end
  end

  def self.subtract_tag(user, tag)
    unless user.nil?
      intersection = self.find_by(tag: tag, user: user)
      intersection.decrement! :entries_count unless intersection.nil?
    end
  end
end
