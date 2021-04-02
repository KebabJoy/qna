FactoryBot.define do
  sequence :body do |n|
    "Answer body#{n}"
  end

  factory :answer do
    body
    question { create(:question) }
    author { create(:user) }

    trait :invalid do
      body { nil }
    end
  end
end
