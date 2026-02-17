class CreateImportProgresses < ActiveRecord::Migration[8.0]
  def change
    create_table :import_progresses do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
