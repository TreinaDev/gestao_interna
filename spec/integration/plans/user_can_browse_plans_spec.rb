require 'rails_helper'

feature 'User can browse plans' do
  scenario 'successfully' do
    log_user_in!
    active_plan = create(:plan, price: 100)
    inactive_plan = create(:plan, :inactive, price: 77.63)

    visit root_path
    click_on 'Planos'

    expect(page).to have_content(active_plan.name)
    expect(page).to have_content('R$ 100,00')
    expect(page).to have_content('Inativo')

    expect(page).to have_content(inactive_plan.name)
    expect(page).to have_content('R$ 77,63')
    expect(page).to have_content('Ativo')
  end

  scenario 'and view details' do
    active_plan = create(:plan, price: 42.42, extra_message_price: 53.53, extra_chat_price: 78.78)
    create(:plan, :inactive)
    log_user_in!

    visit plans_path
    within "tr#plan-#{active_plan.id}" do
      click_on 'Detalhes'
    end

    expect(page).to have_content("Nome #{active_plan.name}")
    expect(page).to have_content("Plataformas #{active_plan.platforms}")
    expect(page).to have_content("Limite de conversas por dia #{active_plan.limit_daily_chat}")
    expect(page).to have_content("Limite de conversas por mês #{active_plan.limit_monthly_chat}")
    expect(page).to have_content("Limite de mensagens por dia #{active_plan.limit_daily_messages}")
    expect(page).to have_content("Limite de mensagens por mês #{active_plan.limit_monthly_messages}")
    expect(page).to have_content('Valor por mensagem além do limite R$ 53,53')
    expect(page).to have_content('Valor por conversa além do limite R$ 78,78')
    expect(page).to have_content('Valor mensal R$ 42,42')
    expect(page).to have_content('Status Ativo')
  end
end
