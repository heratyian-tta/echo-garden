require "faraday"
require "json"

class LocationImporter
  API_URL = "https://example.com/api/locations"

  def self.call
    new.call
  end

  def call
    response = Faraday.get(API_URL)

    unless response.success?
      raise "Location import failed with status #{response.status}"
    end

    locations = JSON.parse(response.body)

    locations.each do |data|
      import_location(data)
    end
  end

  private

  def import_location(data)
    Location.find_or_create_by!(abbreviation: data.fetch("abbreviation")) do |loc|
      loc.country  = data.fetch("country")
      loc.province = data.fetch("province")
      loc.city     = data["city"]
    end
  end
end
