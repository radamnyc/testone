FactoryBot.define do
  factory :cohort do
    association :team
    closing_date { "2024-01-13" }
    energy_type { "MyString" }
    amount { 1 }
  end
end
