# == Schema Information
#
# Table name: import_progresses
#
#  id         :bigint           not null, primary key
#  key        :string
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ImportProgress < ApplicationRecord
end
