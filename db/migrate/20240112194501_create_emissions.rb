class CreateEmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :emissions do |t|
      t.references :team, null: false, foreign_key: true
      t.string :source_type
      t.string :source_reference
      t.string :emission_type
      t.date :effective_date
      t.string :location
      t.string :region
      t.boolean :validated, default: false
      t.text :notes

      t.timestamps
    end
  end
end
