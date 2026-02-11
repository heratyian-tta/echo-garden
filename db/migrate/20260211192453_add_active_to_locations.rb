class AddActiveToLocations < ActiveRecord::Migration[8.0]
  def change
    add_column :locations, :active, :boolean
  end
end
