class RenameTdwgCodeToWgsrpdCodeInLocations < ActiveRecord::Migration[8.0]
  def change
    rename_column :locations, :tdwg_code, :wgsrpd_code
  end
end
