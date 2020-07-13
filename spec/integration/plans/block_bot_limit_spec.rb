require 'rails_helper'

feature 'create plan with block limit' do
  scenario 'successfully' do
    user = create(:user, email: 'aaa@aaa.com', password: '12345678')
    login_as user, scope: :user

    visit root_path
    click_on 'Planos'
    click_on 'Cadastrar novo plano'
    fill_in 'Nome', with: 'Business'
    fill_in 'Valor mensal', with: '99.90'
    fill_in 'Plataformas', with: 'Twitter, Facebook, Whatsapp'
    fill_in 'Limite de conversas por dia', with: '20'
    fill_in 'Limite de conversas por mês', with: '600'
    fill_in 'Limite de mensagens por dia', with: '500'
    fill_in 'Limite de mensagens por mês', with: '5000'
    check 'Bloquear ao atingir limite'
    click_on 'Cadastrar'

    expect(page).to have_content('Business')
    expect(page).to have_content('R$ 99,90')
    expect(page).to have_content('Twitter')
    expect(page).to have_content('Facebook')
    expect(page).to have_content('Whatsapp')
    expect(page).to have_content('20')
    expect(page).to have_content('600')
    expect(page).to have_content('500')
    expect(page).to have_content('5000')
    expect(page).to have_content('O bot é bloqueado ao atingir o limite')
  end
end
