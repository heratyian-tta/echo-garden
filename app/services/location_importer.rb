require "faraday"
require "json"

class LocationImporter
  BASE_URL = "https://api.countrystatecity.in/v1"

  def self.call
    new.call
  end

  def call
    countries.each do |country|
      import_country(country)
    end
  end

  private

  # -------------------------
  # HTTP CLIENT
  # -------------------------
  def client
    @client ||= Faraday.new(url: BASE_URL) do |f|
      f.request :retry, max: 3, interval: 0.5, backoff_factor: 2
      f.options.timeout = 15
      f.options.open_timeout = 5
      f.headers["X-CSCAPI-KEY"] = api_key
      f.headers["Content-Type"] = "application/json"
    end
  end

  def api_key
    ENV.fetch("COUNTRYSTATECITY_API_KEY")
  end

  # -------------------------
  # API CALLS
  # -------------------------
  def countries
    get("/countries/").select { |c| c["iso2"] == "USA" } # Only import US locations for now
  end

  def states(country_code)
    get("/countries/#{country_code}/states")
  end

  def cities(country_code, state_code)
    get("/countries/#{country_code}/states/#{state_code}/cities")
  end

  def get(path)
    response = client.get(path)

    unless response.success?
      raise "CountryStateCity API error (#{response.status}) on #{path}"
    end

    JSON.parse(response.body)
  end

  # -------------------------
  # IMPORT LOGIC
  # -------------------------
  def import_country(country)
    country_code = country.fetch("iso2")
    country_name = country.fetch("name")

    states(country_code).each do |state|
      import_state(
        country_name: country_name,
        country_code: country_code,
        state: state
      )
    end
  end

  def import_state(country_name:, country_code:, state:)
    state_code = state.fetch("iso2")
    state_name = state.fetch("name")

    cities(country_code, state_code).each do |city|
      import_city(
        country_name: country_name,
        state_code: state_code,
        city_name: city["name"]
      )
    end
  end

  def import_city(country_name:, state_code:, city_name:)
    abbreviation = build_abbreviation(country_name, state_code, city_name)

    Location.find_or_create_by!(abbreviation: abbreviation) do |loc|
      loc.country  = country_name
      loc.province = state_code
      loc.city     = city_name
    end
  end

  # -------------------------
  # HELPERS
  # -------------------------
  def build_abbreviation(country, state, city)
    country_code = country.first(2).upcase
    city_code    = city.parameterize.upcase.first(10)

    "#{country_code}-#{state}-#{city_code}"
  end
end
