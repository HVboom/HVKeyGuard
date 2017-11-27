class User < ApplicationRecord
  devise :database_authenticatable, :trackable, :lockable, :timeoutable

  has_and_belongs_to_many :access_groups, uniq: true
  belongs_to :default_access_group, class_name: 'AccessGroup', foreign_key: 'access_group_id', optional: true

  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: /^[a-zA-Z0-9_\.]*$/, multiline: true } # Only allow letter, number, underscore and punctuation.

  after_create :set_default_access_group

  # Virtual attribute for authenticating by either name or email
  # This is in addition to a real persisted field like 'name'
  attr_accessor :login

  def login=(login)
    @login = login
  end

  def login
    @login || self.name || self.email
  end

  def set_default_access_group
    self.default_access_group = AccessGroup.create!(name: self.name)
    self.access_groups << self.default_access_group
    self.save
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(name) = :value OR email = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:name) || conditions.has_key?(:email)
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_h).first
    end
  end
end
