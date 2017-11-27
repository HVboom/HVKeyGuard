class AccessGroup < ApplicationRecord
  has_and_belongs_to_many :users, uniq: true

  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false }
end
