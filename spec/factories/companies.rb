FactoryBot.define do
  factory :company do
    fantasy_name { Faker::Company.name }
    cnpj { Faker::Company.brazilian_company_number(formatted: true) }
    address { Faker::Address.full_address }
    corporate_name { Faker::Company.name }
    blocked { false }
    token { Faker::Code.nric }

    trait :blocked do
      blocked { true }
    end
  end
end
