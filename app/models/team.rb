class Team < ApplicationRecord
  include Teams::Base
  include Webhooks::Outgoing::TeamSupport
  # 🚅 add concerns above.

  # 🚅 add belongs_to associations above.

  has_many :projects, dependent: :destroy
  has_many :data_files, dependent: :destroy
  has_many :emissions, dependent: :destroy
  has_many :cohorts, dependent: :destroy
  # 🚅 add has_many associations above.

  # 🚅 add oauth providers above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.
  enum team_type: { inactive: 0, client: 1, admin: 2 }
  # 🚅 add delegations above.

  # 🚅 add methods above.
end
