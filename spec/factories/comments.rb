FactoryBot.define do
  factory :comment do
    body { "MyString" }
  end

  trait :invalid do
    body { nil }
  end
end
