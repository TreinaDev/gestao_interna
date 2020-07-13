FactoryBot.define do
  factory :purchase do
    company
    plan
    price { 1.5 }
    email { 'MyString' }
    status { :active }
  end
end
