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
class Garden < ApplicationRecord
  belongs_to :user
  has_many :garden_plots, dependent: :destroy
  has_many :plants, through: :garden_plots
end
