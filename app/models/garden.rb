class Garden < ApplicationRecord
  belongs_to :user
  has_many :garden_plots, dependent: :destroy
  has_many :plants, through: :garden_plots
end
