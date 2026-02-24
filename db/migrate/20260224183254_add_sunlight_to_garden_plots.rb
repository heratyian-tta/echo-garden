class AddSunlightToGardenPlots < ActiveRecord::Migration[8.0]
  def change
    add_column :garden_plots, :sunlight, :string
  end
end
