FactoryBot.define do
  factory :comment do
    body { 'MyString' }
    author { create(:user) }
  end

  trait :invalid do
    body { nil }
  end
end
