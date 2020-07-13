FactoryBot.define do
  factory :purchase_cancellation do
    purchase
    status { :open }
    user { nil }

    trait :with_a_reason do
      reason { Faker::Lorem.sentence }
    end

    trait :approved do
      status { :approved }
    end

    trait :rejected do
      status { :rejected }
    end
  end
end
