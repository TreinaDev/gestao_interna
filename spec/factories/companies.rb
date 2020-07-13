FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    cnpj { Faker::Company.brazilian_company_number(formatted: true) }
    address { Faker::Address.full_address }
    corporate_name { Faker::Company.name }
    blocked { false }

    trait :blocked do
      blocked { true }
    end
  end
end
