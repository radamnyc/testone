class Project < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  # 🚅 add belongs_to associations above.

  has_many :project_emissions, dependent: :destroy
  has_many :emissions, through: :project_emissions
  has_many :project_data_files, dependent: :destroy
  has_many :data_files, through: :project_data_files
  has_many :cohort_subscriptions, dependent: :destroy
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.
end
