# == Schema Information
#
# Table name: plants
#
#  id                 :bigint           not null, primary key
#  bloom_months       :string           default([]), is an Array
#  common_names       :string           default([]), is an Array
#  family_name        :string
#  flower_colors      :string           default([]), is an Array
#  flowering_seasons  :string           default([]), is an Array
#  genus_name         :string
#  habitat            :text
#  image_url          :string
#  invasive_alert     :boolean          default(FALSE), not null
#  leaf_colors        :string           default([]), is an Array
#  light_requirements :string           default([]), is an Array
#  native_states      :string           default([]), is an Array
#  noxious            :boolean          default(FALSE), not null
#  plant_habits       :string           default([]), is an Array
#  raw_api_payload    :jsonb
#  scientific_name    :string           not null
#  soil_moisture      :string           default([]), is an Array
#  taxonomic_rank     :string
#  usda_symbol        :string
#  water_use          :string           default([]), is an Array
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  api_id             :integer          not null
#
# Indexes
#
#  index_plants_on_api_id           (api_id) UNIQUE
#  index_plants_on_flower_colors    (flower_colors) USING gin
#  index_plants_on_native_states    (native_states) USING gin
#  index_plants_on_plant_habits     (plant_habits) USING gin
#  index_plants_on_scientific_name  (scientific_name) UNIQUE
#
class Plant < ApplicationRecord
end
