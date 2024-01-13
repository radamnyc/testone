class CreateCohortSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :cohort_subscriptions do |t|
      t.references :project, null: false, foreign_key: true
      t.references :cohort, null: false, foreign_key: true

      t.timestamps
    end
  end
end
