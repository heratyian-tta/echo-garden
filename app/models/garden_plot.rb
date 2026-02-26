# == Schema Information
#
# Table name: garden_plots
#
#  id         :bigint           not null, primary key
#  column     :integer
#  row        :integer
#  sunlight   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  garden_id  :bigint
#  plant_id   :bigint
#
# Indexes
#
#  index_garden_plots_on_garden_id  (garden_id)
#  index_garden_plots_on_plant_id   (plant_id)
#
# Foreign Keys
#
#  fk_rails_...  (garden_id => gardens.id)
#  fk_rails_...  (plant_id => plants.id)
#
# app/models/garden_plot.rb
class GardenPlot < ApplicationRecord
  belongs_to :plant, optional: true
  belongs_to :garden
  

  validates :row, :column, presence: true

  # Set default sunlight
  after_initialize :set_default_sunlight, if: :new_record?

  private

  def set_default_sunlight
    self.sunlight ||= "sunny"  # Default to sunny; can improve later
  end
end
