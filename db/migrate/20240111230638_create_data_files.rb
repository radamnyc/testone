class CreateDataFiles < ActiveRecord::Migration[7.1]
  def change
    create_table :data_files do |t|
      t.references :team, null: false, foreign_key: true
      t.string :description
      t.string :type
      t.date :relevant_date
      t.boolean :valid, default: false
      t.text :notes

      t.timestamps
    end
  end
end
