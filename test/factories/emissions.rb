FactoryBot.define do
  factory :emission do
    association :team
    source_type { "MyString" }
    source_reference { "MyString" }
    emission_type { "MyString" }
    effective_date { "2024-01-12" }
    location { "MyString" }
    region { "MyString" }
    validated { false }
    notes { "MyText" }
  end
end
