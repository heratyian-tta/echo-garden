class CreatePlants < ActiveRecord::Migration[8.0]
  def change
    create_table :plants do |t|
      # Identity
      t.integer :api_id, null: false
      t.string :scientific_name, null: false
      t.string :family_name
      t.string :genus_name
      t.string :usda_symbol
      t.string :taxonomic_rank

      # Arrays (Postgres)
      t.string :common_names, array: true, default: []
      t.string :native_states, array: true, default: []
      t.string :plant_habits, array: true, default: []
      t.string :flower_colors, array: true, default: []
      t.string :leaf_colors, array: true, default: []
      t.string :bloom_months, array: true, default: []
      t.string :flowering_seasons, array: true, default: []
      t.string :light_requirements, array: true, default: []
      t.string :soil_moisture, array: true, default: []
      t.string :water_use, array: true, default: []

      # Visual / habitat
      t.string :image_url
      t.text :habitat

      # Flags
      t.boolean :invasive_alert, default: false, null: false
      t.boolean :noxious, default: false, null: false

      # Store full API response if needed
      t.jsonb :raw_api_payload

      t.timestamps
    end

    # Indexes
    add_index :plants, :api_id, unique: true
    add_index :plants, :scientific_name, unique: true
    add_index :plants, :native_states, using: :gin
    add_index :plants, :plant_habits, using: :gin
    add_index :plants, :flower_colors, using: :gin
  end
end
