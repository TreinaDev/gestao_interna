require 'rails_helper'

describe 'Register Purchase' do
  context 'POST api/v1/purchases' do
    it 'successfully receive all required params' do
      plan = create(:plan, name: 'Plano Top', price: 20)
      company = create(:company, token: '12345', name: 'Empresa A')

      post '/api/v1/purchases', params: { purchase: { company_token: company.token, plan_id: plan.id } }
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect((json_response[:company][:name])).to eq(company.name)
      expect((json_response[:plan][:name])).to eq(plan.name)
    end

    it 'and must receive plan id' do
      company = create(:company, token: '12345', name: 'Empresa A')

      post '/api/v1/purchases', params: { purchase: { company_token: company.token, plan_id: '', price: 20 } }
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
      expect(json_response[:error]).to eq 'Plano não encontrada(o).'
    end

    it 'and must receive company token' do
      plan = create(:plan)

      post '/api/v1/purchases', params: { purchase: { company_token: '', plan_id: plan.id, price: plan.price } }
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
      expect(json_response[:error]).to eq 'Empresa não encontrada(o).'
    end

    it 'must receive purchase' do
      post '/api/v1/purchases', params: {}
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:bad_request)
      expect(json_response[:error]).to eq 'Parametros invalidos, verifique o corpo da requisição.'
    end

    it 'must receive company token and plan id' do
      post '/api/v1/purchases', params: { purchase: { price: 40 } }
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:bad_request)
      expect(json_response[:error]).to eq 'Parametros invalidos, verifique o corpo da requisição.'
    end

    it 'should return an error for a blocked company' do
      plan = create(:plan)
      company = create(:company, :blocked)

      post '/api/v1/purchases', params: { purchase: { company_token: company.token, plan_id: plan.id } }
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:error].first).to eq 'Empresa bloqueada de fazer novas compras.'
    end
  end
end
