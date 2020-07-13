require 'rails_helper'

feature 'User register plan' do
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
    fill_in 'Valor por mensagem além do limite', with: '0.10'
    fill_in 'Valor por conversa além do limite', with: '0.99'
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
    expect(page).to have_content('R$ 0,10')
    expect(page).to have_content('R$ 0,99')
  end

  scenario 'cannot be blank' do
    user = create(:user, email: 'aaa@aaa.com', password: '12345678')
    login_as user, scope: :user

    visit root_path
    click_on 'Planos'
    click_on 'Cadastrar novo plano'
    click_on 'Cadastrar'

    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Valor mensal não pode ficar em branco')
    expect(page).to have_content('Plataformas não pode ficar em branco')
    expect(page).to have_content('Limite de conversas por dia não pode ficar em branco')
    expect(page).to have_content('Limite de conversas por mês não pode ficar em branco')
    expect(page).to have_content('Limite de mensagens por dia não pode ficar em branco')
    expect(page).to have_content('Limite de mensagens por mês não pode ficar em branco')
    expect(page).to have_content('Valor por mensagem além do limite não pode ficar em branco')
    expect(page).to have_content('Valor por conversa além do limite não pode ficar em branco')
  end

  scenario 'name must be unique' do
    user = create(:user, email: 'aaa@aaa.com', password: '12345678')
    login_as user, scope: :user
    create(:plan, name: 'Business')

    visit root_path
    click_on 'Planos'
    click_on 'Cadastrar novo plano'
    click_on 'Cadastrar'
    fill_in 'Nome', with: 'Business'
    fill_in 'Valor mensal', with: '99.90'
    fill_in 'Plataformas', with: 'Twitter, Facebook, Whatsapp'
    fill_in 'Limite de conversas por dia', with: '20'
    fill_in 'Limite de conversas por mês', with: '600'
    fill_in 'Limite de mensagens por dia', with: '500'
    fill_in 'Limite de mensagens por mês', with: '5000'
    fill_in 'Valor por mensagem além do limite', with: '0.10'
    fill_in 'Valor por conversa além do limite', with: '0.99'
    click_on 'Cadastrar'

    expect(page).to have_content('Nome já está em uso')
  end
end
