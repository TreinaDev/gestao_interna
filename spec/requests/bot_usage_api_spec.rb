require 'rails_helper'

describe 'User require Bot usage' do
  context 'GET /api/v1/bot_usage' do
    it 'should return the bot usage at the current month' do
      bot = create(:bot, created_at: 2.days.ago)
      create_list(:bot_chat, 5, :end_conversation, bot: bot, message_count: 3)

      get api_v1_bot_usage_path, params: { bot: { token: bot.token } }

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:ok)
      expect(json_response[:month]).to eq(Time.zone.today.strftime('%Y-%m'))
      expect(json_response[:total_chats]).to eq(5)
      expect(json_response[:total_messages]).to eq(15)
      expect(json_response[:monthly_cost]).to eq(bot.purchase.price_when_bought)
    end

    it 'should add extra chat and message usage to monthly cost' do
      plan = create(:plan, price: 30.00, limit_monthly_chat: 2, limit_monthly_messages: 5,
                           extra_chat_price: 2.5, extra_message_price: 1.5)
      purchase = create(:purchase, plan: plan)
      bot = create(:bot, purchase: purchase, created_at: 2.days.ago)
      create_list(:bot_chat, 4, :end_conversation, bot: bot, message_count: 3)

      get api_v1_bot_usage_path, params: { bot: { token: bot.token } }

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:ok)
      expect(json_response[:month]).to eq(Time.zone.today.strftime('%Y-%m'))
      expect(json_response[:total_chats]).to eq(4)
      expect(json_response[:total_messages]).to eq(12)
      expect(json_response[:monthly_cost]).to eq(30 + 5 + 10.5)
    end

    it 'can recieve a date param a generate a report for that month' do
      plan = create(:plan, limit_monthly_chat: 3, limit_monthly_messages: 4,
                           extra_chat_price: 5, extra_message_price: 3.5,
                           created_at: '2020-02-01')
      create(:plan_price, plan: plan, created_at: '2020-02-09', value: 83.00)
      purchase = create(:purchase, plan: plan, created_at: '2020-02-10')
      bot = create(:bot, purchase: purchase, created_at: '2020-02-10')
      create_list(:bot_chat, 6, :end_conversation, bot: bot, message_count: 7,
                                                   created_at: '2020-03-10')

      get api_v1_bot_usage_path, params: {
        bot: { token: bot.token },
        date: '2020-03-25'
      }

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:ok)
      expect(json_response[:month]).to eq('2020-03')
      expect(json_response[:total_chats]).to eq(6)
      expect(json_response[:total_messages]).to eq(42)
      expect(json_response[:monthly_cost]).to eq(83 + 15 + 38 * 3.5)
    end

    it 'should return unprocessable entity for invalid date format' do
      bot = create(:bot)

      get api_v1_bot_usage_path, params: {
        bot: { token: bot.token },
        date: 'yolo'
      }

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:error]).to eq('Data não é valida.')
    end

    it 'should return unprocessable entity for invalid date' do
      bot = create(:bot, created_at: '2020-04-11')

      get api_v1_bot_usage_path, params: {
        bot: { token: bot.token },
        date: '2020-03-11'
      }

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:error]).to eq('Data não é valida.')
    end

    it 'should return not found for an invalid bot token' do
      get api_v1_bot_usage_path, params: { bot: { token: 'A8M292' } }

      expect(response).to have_http_status(:not_found)
    end
  end
end
