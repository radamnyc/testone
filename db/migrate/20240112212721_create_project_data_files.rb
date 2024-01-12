class CreateProjectDataFiles < ActiveRecord::Migration[7.1]
  def change
    create_table :project_data_files do |t|
      t.references :project, null: false, foreign_key: true
      t.references :data_file, null: false, foreign_key: true

      t.timestamps
    end
  end
end
