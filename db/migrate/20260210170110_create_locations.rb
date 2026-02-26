class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :country, null: false
      t.string :province, null: false
      t.string :city
      t.string :abbreviation, null: false, limit: 10

      t.timestamps
    end

    add_index :locations,
      [:country, :province, :city],
      unique: true,
      name: "index_locations_on_country_province_city"
  
  end
end
