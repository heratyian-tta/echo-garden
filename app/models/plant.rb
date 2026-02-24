class Plant < ApplicationRecord
  has_many :plant_native_regions, dependent: :destroy
  has_many :native_regions,
           through: :plant_native_regions,
           source: :location

  validates :scientific_name, presence: true, uniqueness: true

  def add_native_region(wgsrpd_code)
    location = Location.find_by(wgsrpd_code: wgsrpd_code)
    return unless location

    plant_native_regions.find_or_create_by(location: location)
  end
end
