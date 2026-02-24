class GardenPlot < ApplicationRecord
  belongs_to :garden
  belongs_to :plant, optional: true

  validates :row, :column, presence: true
end
