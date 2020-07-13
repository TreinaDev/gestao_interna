require 'rails_helper'

RSpec.describe Bot, type: :model do
  subject { create :bot }

  it 'has relations' do
    expect(subject).to belong_to(:company)
    expect(subject).to belong_to(:purchase)
    expect(subject).to have_many(:chats).class_name('BotChat')
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'validates unique attributes' do
    expect(subject).to validate_uniqueness_of(:token)
  end

  it 'Create after purchase' do
    purchase = create(:purchase)

    expect(Bot.count).to eq 1
    expect(Bot.last.purchase).to eq purchase
  end

  context 'token' do
    it 'should generate a token on create' do
      expect(subject.token).to match RegexSupport::VALID_TOKEN_REGEX
    end

    it 'generates a unique token' do
      bot = build(:bot)
      allow(SecureRandom).to receive(:alphanumeric).and_return(subject.token, 'ABC123', 'GGG000', 'FFF678', 'CCC100')

      bot.save
      expect(bot.token).not_to eq(subject.token)
    end
  end
end
