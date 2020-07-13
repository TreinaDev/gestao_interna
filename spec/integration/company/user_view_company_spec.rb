require 'rails_helper'

feature 'User view company' do
  scenario 'successfully' do
    log_user_in!
    company1 = create(:company, name: 'Treinadev', token: '123456')
    company2 = create(:company, name: 'Campus Code', token: '654321')

    visit root_path
    click_on 'Ver Empresas'

    expect(page).to have_content('Empresas Cadastradas')
    expect(current_path).to eq(companies_path)
    expect(page).to have_content(company1.name)
    expect(page).to have_content(company1.token)
    expect(page).to have_content(company2.name)
    expect(page).to have_content(company2.token)
  end

  scenario 'User view company details' do
    log_user_in!
    company1 = create(:company, name: 'Treinadev', token: '123456')
    company2 = create(:company, name: 'Acme Corp', token: '654321')
    bot1 = create(:bot, company: company1)
    bot2 = create(:bot, company: company2, token: '12345678')

    visit root_path
    click_on 'Ver Empresas'
    within "tr#company-#{company1.id}" do
      click_on 'Detalhes'
    end

    expect(page).to have_content(company1.name)
    expect(page).to have_content(company1.token)
    expect(page).to have_content(bot1.token)
    expect(page).not_to have_content(company2.name)
    expect(page).not_to have_content(company2.token)
    expect(page).not_to have_content(bot2.token)
  end

  context 'Company blocked' do
    scenario 'see all companies' do
      log_user_in!
      company1 = create(:company, name: 'Treinadev', token: '123456')
      company2 = create(:company, name: 'Campus Code', token: '654321')
      company1.block!

      visit root_path
      click_on 'Ver Empresas'

      expect(page).to have_content('Empresas Cadastradas')
      expect(current_path).to eq(companies_path)
      expect(page).to have_content('Bloqueada')
      expect(page).to have_content(company1.name)
      expect(page).to have_content(company1.token)
      expect(page).to have_content(company2.name)
      expect(page).to have_content(company2.token)
    end

    scenario 'User view company details' do
      log_user_in!
      company1 = create(:company, name: 'Treinadev', token: '123456')
      company2 = create(:company, name: 'Acme Corp', token: '654321')
      bot1 = create(:bot, company: company1)
      bot2 = create(:bot, company: company2, token: '12345678')
      company1.block!

      visit root_path
      click_on 'Ver Empresas'
      within "tr#company-#{company1.id}" do
        click_on 'Detalhes'
      end

      expect(page).to have_content(company1.name)
      expect(page).to have_content(company1.token)
      expect(page).to have_content('Bloqueada')
      expect(page).to have_content(bot1.token)
      expect(page).to have_content('Bloqueado')
      expect(page).not_to have_content(company2.name)
      expect(page).not_to have_content(company2.token)
      expect(page).not_to have_content(bot2.token)
      expect(page).not_to have_content(bot2.status)
    end
  end
end
