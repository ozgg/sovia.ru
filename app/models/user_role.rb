class UserRole < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  validates_presence_of :user, :role
  validates_uniqueness_of :role, scope: :user

  enum role: [:administrator, :moderator, :dreams_manager, :dreambook_editor, :dreambook_manager, :posts_manager]

  def self.roles_for_select
    self.roles.keys.to_a.map { |e| [t("activerecord.attributes.user_role.roles.#{e}"), e] }
  end
end
