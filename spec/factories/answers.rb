FactoryBot.define do
  factory :answer do
    body { "MyString" }
    question { nil }
    author { create(:user) }

    trait :invalid do
      body { nil }
    end
  end
end
