class CreateProjectEmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :project_emissions do |t|
      t.references :project, null: false, foreign_key: true
      t.references :emission, null: false, foreign_key: true

      t.timestamps
    end
  end
end
