FactoryBot.define do
  factory :bot do
    company
    purchase
    status { :active }
    token { 'MMM000' }
  end
end
