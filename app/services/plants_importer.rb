# app/services/plants_importer.rb
require 'net/http'
require 'uri'
require 'json'

class PlantsImporter
  API_URL = 'https://api.floraapi.com/v1/export/bulk'
  API_KEY = ENV['FLORA_API_KEY']

  TARGET_STATES   = %w[IL IN OH WI].freeze
  TARGET_FAMILIES = %w[Asteraceae Poaceae Lamiaceae Ranunculaceae Caprifoliaceae].freeze
  LIMIT = 100

  # Public entry point for cron
  def self.call
    state = next_state
    family = next_family
    letter = next_letter

    puts "=== Importing plants for #{state}, family #{family}, starting with letter #{letter} ==="

    plants_data = fetch_plants(state: state, family_name: family, limit: LIMIT, scientific_name_starts_with: letter)
    if plants_data.empty?
      puts "No plants returned for #{state}, #{family}, letter #{letter}"
    else
      plants_data.each { |plant| save_plant(plant) }
    end

    # Update rotation to next letter/family/state
    advance_rotation(state, family, letter)
  end

  private_class_method

  def self.next_state
    last = ImportProgress.find_by(key: 'last_state')&.value
    idx = TARGET_STATES.index(last) || -1
    TARGET_STATES[(idx + 1) % TARGET_STATES.size]
  end

  def self.next_family
    last = ImportProgress.find_by(key: 'last_family')&.value
    idx = TARGET_FAMILIES.index(last) || -1
    TARGET_FAMILIES[(idx + 1) % TARGET_FAMILIES.size]
  end

  def self.next_letter
    last = ImportProgress.find_by(key: 'last_letter')&.value || 'A'
    if last == 'Z'
      'A'
    else
      (last.ord + 1).chr
    end
  end

  def self.advance_rotation(state, family, letter)
    # Save last letter
    ImportProgress.find_or_create_by(key: 'last_letter').update(value: letter)

    # If we finished 'Z', move to next family
    if letter == 'Z'
      next_fam = TARGET_FAMILIES[(TARGET_FAMILIES.index(family) + 1) % TARGET_FAMILIES.size]
      ImportProgress.find_or_create_by(key: 'last_family').update(value: next_fam)

      # If we wrapped families, move to next state
      if next_fam == TARGET_FAMILIES.first
        next_st = TARGET_STATES[(TARGET_STATES.index(state) + 1) % TARGET_STATES.size]
        ImportProgress.find_or_create_by(key: 'last_state').update(value: next_st)
      end
    end
  end

  # Fetch plants from Flora API
  def self.fetch_plants(state:, family_name:, limit:, scientific_name_starts_with:)
    params = {
      format: 'json',
      state: state,
      family_name: family_name,
      limit: limit,
      scientific_name_contains: scientific_name_starts_with
    }

    uri = URI(API_URL)
    uri.query = URI.encode_www_form(params)

    request = Net::HTTP::Get.new(uri)
    request['Accept'] = 'application/json'
    request['Authorization'] = "Bearer #{API_KEY}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    case response
    when Net::HTTPSuccess
      data = JSON.parse(response.body)
      data['species'] || []
    else
      puts "API returned #{response.code} #{response.message}"
      []
    end
  rescue StandardError => e
    puts "Error fetching plants: #{e.message}"
    []
  end

  # Save plant to DB
  def self.save_plant(plant_data)
    plant = Plant.find_or_initialize_by(api_id: plant_data['id'])
    plant.assign_attributes(
      scientific_name: plant_data['scientific_name'],
      common_names: plant_data['common_names'] || [],
      family_name: plant_data['family_name'],
      genus_name: plant_data['genus_name'],
      usda_symbol: plant_data['usda_symbol'],
      taxonomic_rank: plant_data['taxonomic_rank'],
      native_states: plant_data['nativity'] || [],
      plant_habits: plant_data['plant_habits'] || [],
      flower_colors: plant_data['flower_colors'] || [],
      leaf_colors: plant_data['leaf_colors'] || [],
      bloom_months: plant_data['bloom_months'] || [],
      flowering_seasons: plant_data['flowering_seasons'] || [],
      light_requirements: plant_data['light_requirements'] || [],
      soil_moisture: plant_data['soil_moisture'] || [],
      water_use: plant_data['water_use'] || [],
      image_url: plant_data['preferred_image_url'],
      habitat: plant_data['habitat'],
      invasive_alert: plant_data['invasive_alert'] || false,
      noxious: plant_data['noxious'] || false,
      raw_api_payload: plant_data
    )
    plant.save!
  end
end
