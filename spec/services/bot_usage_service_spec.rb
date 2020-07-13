require 'rails_helper'

RSpec.describe BotUsageService do
  describe 'self.call' do
    it 'should return bots usage with valid params' do
      plan = create(:plan, price: 200.00, limit_monthly_chat: 15, limit_monthly_messages: 400,
                           extra_chat_price: 2.5, extra_message_price: 1.5)
      purchase = create(:purchase, plan: plan)
      bot = create(:bot, purchase: purchase, created_at: 2.days.ago)
      create_list(:bot_chat, 20, :end_conversation, bot: bot, message_count: 100)

      params = { bot: bot, raw_date: nil }
      results =  described_class.call(params)

      expect(results).to eq({
                              month: '2020-07',
                              total_chats: 20,
                              total_messages: 2000,
                              monthly_cost: 200 + 5 * 2.5 + 1600 * 1.5
                            })
    end

    it 'should raise execption if data is before bot creation' do
      plan = create(:plan, price: 30.00, limit_monthly_chat: 2, limit_monthly_messages: 5,
                           extra_chat_price: 2.5, extra_message_price: 1.5, created_at: '2020-07-05')
      purchase = create(:purchase, plan: plan, created_at: '2020-07-07')
      bot = create(:bot, purchase: purchase, created_at: '2020-07-07')
      create_list(:bot_chat, 5, :end_conversation, bot: bot, message_count: 3, created_at: '2020-07-08')

      params = { bot: bot, raw_date: '2020-02-20' }
      expect { described_class.call(params) }.to raise_error(ArgumentError)
    end

    it 'should raise execption if date is unparsable' do
      bot = create(:bot)

      params = { bot: bot, raw_date: 'yolo' }
      expect { described_class.call(params) }.to raise_error(ArgumentError)
    end

    it 'should raise execption if without bot' do
      params = { bot: nil, raw_date: '2020-02-20' }

      expect { described_class.call(params) }.to raise_error(ArgumentError)
    end
  end

  describe 'private: monthly_cost' do
    it 'should the months cost including extra charges' do
      plan = create(:plan, price: 894.13, limit_monthly_chat: 23, limit_monthly_messages: 123,
                           extra_chat_price: 23.4, extra_message_price: 0.6)
      purchase = create(:purchase, plan: plan)
      bot = create(:bot, purchase: purchase)
      create_list(:bot_chat, 40, :end_conversation, bot: bot, message_count: 5)

      params = { bot: bot, raw_date: nil }
      subject = described_class.new(params)

      expect(subject.send(:monthly_cost)).to eq(894.13 + 17 * 23.4 + 77 * 0.6)
    end
  end

  describe 'private: total_messages' do
    it 'should return the total number of sent messages' do
      bot = create(:bot)
      create_list(:bot_chat, 39, :end_conversation, bot: bot, message_count: 2)
      create_list(:bot_chat, 57, :end_conversation, bot: bot, message_count: 4)

      params = { bot: bot, raw_date: nil }
      subject = described_class.new(params)

      expect(subject.send(:total_messages)).to eq(306)
    end
  end

  describe 'private: total_chats' do
    it 'should return the total number of chats' do
      bot = create(:bot)
      create_list(:bot_chat, 8, bot: bot)
      create_list(:bot_chat, 13, bot: bot)
      create_list(:bot_chat, 21, bot: bot)
      create_list(:bot_chat, 34, bot: bot)
      create_list(:bot_chat, 55, bot: bot)

      params = { bot: bot, raw_date: nil }
      subject = described_class.new(params)

      expect(subject.send(:total_chats)).to eq(131)
    end
  end
end
