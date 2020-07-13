require 'rails_helper'

describe 'Plan management' do
  context 'GET /api/v1/plans' do
    it 'returns all active plans' do
      create_list(:plan, 2, :inactive)
      active_plans = create_list(:plan, 5)

      get api_v1_plans_path

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json_response.count).to eq(5)
      (0..4).each do |index|
        expect(json_response[index][:name]).to eq(active_plans[index].name)
        expect(json_response[index][:platforms]).to eq(active_plans[index].platforms)
        expect(json_response[index][:limit_daily_chat]).to eq(active_plans[index].limit_daily_chat)
        expect(json_response[index][:limit_monthly_chat]).to eq(active_plans[index].limit_monthly_chat)
        expect(json_response[index][:limit_daily_messages]).to eq(active_plans[index].limit_daily_messages)
        expect(json_response[index][:limit_monthly_messages]).to eq(active_plans[index].limit_monthly_messages)
        expect(json_response[index][:extra_message_price]).to eq(active_plans[index].extra_message_price)
        expect(json_response[index][:extra_chat_price]).to eq(active_plans[index].extra_chat_price)
        expect(json_response[index][:current_price]).to eq(active_plans[index].current_price)
        expect(json_response[index][:status]).to eq('active')
      end
    end

    it 'returns empty array without plans' do
      get api_v1_plans_path

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response).to be_empty
    end
  end

  context 'GET /api/v1/plans/:id' do
    it 'returns a single plan' do
      plan = create(:plan)

      get api_v1_plan_path(1)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response[:name]).to eq(plan.name)
      expect(json_response[:platforms]).to eq(plan.platforms)
      expect(json_response[:limit_daily_chat]).to eq(plan.limit_daily_chat)
      expect(json_response[:limit_monthly_chat]).to eq(plan.limit_monthly_chat)
      expect(json_response[:limit_daily_messages]).to eq(plan.limit_daily_messages)
      expect(json_response[:limit_monthly_messages]).to eq(plan.limit_monthly_messages)
      expect(json_response[:extra_message_price]).to eq(plan.extra_message_price)
      expect(json_response[:extra_chat_price]).to eq(plan.extra_chat_price)
      expect(json_response[:current_price]).to eq(plan.current_price)

      expect(response.body).to include(plan.current_price.to_s)
    end

    it 'returns not found' do
      get api_v1_plan_path(1)

      expect(response).to have_http_status(:not_found)

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:error]).to eq 'Plano não encontrada(o).'
    end
  end
end
