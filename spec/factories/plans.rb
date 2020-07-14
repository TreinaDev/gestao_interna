FactoryBot.define do
  factory :plan do
    price { Faker::Number.unique.decimal(l_digits: 3, r_digits: 2) }
    name { Faker::Lorem.unique.sentence }
    platforms { ['Facebook', 'Twitter', 'Whatsapp', 'Uol'].sample }
    limit_daily_chat { Faker::Number.within(range: 10..100) }
    limit_monthly_chat { Faker::Number.within(range: 10..100) }
    limit_daily_messages { Faker::Number.within(range: 10..100) }
    limit_monthly_messages { Faker::Number.within(range: 10..100) }
    extra_message_price { Faker::Number.normal(mean: 1, standard_deviation: 1) }
    extra_chat_price { Faker::Number.normal(mean: 1, standard_deviation: 1) }
    status { :active }

    trait :inactive do
      status { :inactive }
    end
  end
end
