class CreateCohorts < ActiveRecord::Migration[7.1]
  def change
    create_table :cohorts do |t|
      t.references :team, null: false, foreign_key: true
      t.date :closing_date
      t.string :energy_type
      t.integer :amount

      t.timestamps
    end
  end
end
