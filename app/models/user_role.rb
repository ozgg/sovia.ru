class UserRole < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user, :role
  validates_uniqueness_of :role, scope: :user

  enum role: [
                 :administrator, :moderator, :dreams_manager, :dreambook_editor, :dreambook_manager, :posts_manager,
                 :content_editor
             ]

  def self.roles_for_select
    self.roles.keys.to_a.map { |e| [I18n.t("activerecord.attributes.user_role.roles.#{e}"), e] }
  end

  def self.role_for_user(role, user)
    if self.roles.has_key? role
      self.where(user: user, role: self.roles[role]).first
    else
      nil
    end
  end

  def self.exists_for_user?(role, user)
    !self.role_for_user(role, user).nil?
  end

  def name
    if UserRole.roles.has_key? role
      role
    end
  end
end
