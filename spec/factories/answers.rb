FactoryBot.define do
  factory :answer do
    body { 'Answer body' }
    question { nil }
    author { create(:user) }

    trait :invalid do
      body { nil }
    end
  end
end
