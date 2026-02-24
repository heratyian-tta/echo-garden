class CreateGardens < ActiveRecord::Migration[8.0]
  def change
    create_table :gardens do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.integer :rows
      t.integer :columns

      t.timestamps
    end
  end
end
