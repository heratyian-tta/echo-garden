# == Schema Information
#
# Table name: gardens
#
#  id         :bigint           not null, primary key
#  columns    :integer
#  name       :string
#  rows       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_gardens_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
# app/models/garden.rb
class Garden < ApplicationRecord
  belongs_to :user
  has_many :garden_plots, dependent: :destroy

  after_create :generate_plots

  def generate_plots
    rows.times do |row|
      columns.times do |col|
        garden_plots.create!(
          row_position: row,
          column_position: col
        )
      end
    end
  end
end
