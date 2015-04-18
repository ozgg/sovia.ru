class Account < ActiveRecord::Base
  include HasLanguage

  belongs_to :user

  has_many :questions, as: :owner, dependent: :destroy
  has_many :comments, as: :owner, dependent: :destroy

  enum network: [:vk]
  enum gender: [:female, :male]

  validates_presence_of :network, :local_id
  validates_uniqueness_of :local_id, scope: [:network]

  mount_uploader :avatar, AvatarUploader

  def self.networks_for_form
    networks.keys.to_a.map { |e| [e, e] }
  end

  def self.genders_for_form
    [[I18n.t(:not_selected), '']] + genders.keys.to_a.map { |e| [I18n.t("activerecord.attributes.account.genders.#{e}"), e] }
  end

end
