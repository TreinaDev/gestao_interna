require 'rails_helper'

RSpec.describe Purchase, type: :model do
  subject { create :purchase }

  it 'has relations' do
    expect(subject).to belong_to(:plan)
    expect(subject).to belong_to(:company)
    expect(subject).to have_many(:bots)
    expect(subject).to have_many(:cancellation_requests).class_name('PurchaseCancellation')
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  context 'token' do
    it 'should generate a token when created' do
      subject.save

      expect(subject.token).to match RegexSupport::VALID_TOKEN_REGEX
    end

    it 'should generate an unique token' do
      another_purchase = create(:purchase)
      allow(SecureRandom).to receive(:alphanumeric).and_return(another_purchase.token, 'ABC123')
      subject.save

      expect(subject.token).not_to eq(another_purchase.token)
    end
  end

  it 'method: price_when_bought' do
    plan = create(:plan, price: 53.17)
    purchase = create(:purchase, plan: plan)
    create(:plan_price, plan: plan)

    expect(purchase.price_when_bought).to eq(53.17)
  end
end
