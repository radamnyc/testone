FactoryBot.define do
  factory :data_file do
    association :team
    description { "MyString" }
    type { "" }
    relevant_date { "2024-01-11" }
    file { nil }
    valid { false }
    notes { "MyText" }
  end
end
