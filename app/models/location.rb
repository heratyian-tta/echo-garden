class Location < ApplicationRecord
  has_many :users

  validates :country, :province, :abbreviation, presence: true
  validates :abbreviation, uniqueness: true
end
