class AddNewColumnToTeam < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :team_type, :integer
  end
end
