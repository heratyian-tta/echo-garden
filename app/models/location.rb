# == Schema Information
#
# Table name: locations
#
#  id           :bigint           not null, primary key
#  abbreviation :string(10)       not null
#  city         :string
#  country      :string           not null
#  province     :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_locations_on_country_province_city  (country,province,city) UNIQUE
#
class Location < ApplicationRecord
  has_many :users

  validates :country, :province, :abbreviation, presence: true
  validates :abbreviation, uniqueness: true
end
