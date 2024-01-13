FactoryBot.define do
  factory :cohort_subscription do
    association :project
    cohort { nil }
    state_of_interest { "MyString" }
    amount { 1 }
  end
end
