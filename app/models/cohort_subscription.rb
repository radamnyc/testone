class CohortSubscription < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :project
  belongs_to :cohort
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :project
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :cohort, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_cohorts
    raise "please review and implement `valid_cohorts` in `app/models/cohort_subscription.rb`."
    # please specify what objects should be considered valid for assigning to `cohort`.
    # the resulting code should probably look something like `team.cohorts`.
  end

  # 🚅 add methods above.
end
