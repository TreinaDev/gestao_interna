FactoryBot.define do
  factory :plan do
    price { Faker::Number.unique.decimal(l_digits: 3, r_digits: 2) }
    name { Faker::Lorem.unique.sentence }
    platforms { 'MyString' }
    limit_daily_chat { 20 }
    limit_monthly_chat { 20 }
    limit_daily_messages { 20 }
    limit_monthly_messages { 20 }
    extra_message_price { 1.5 }
    extra_chat_price { 1.5 }
    status { :active }

    trait :inactive do
      status { :inactive }
    end
  end
end
