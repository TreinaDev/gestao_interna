require 'rails_helper'

feature 'User block bot' do
  scenario 'successfully' do
    log_user_in!
    bot = create(:bot)

    visit bots_path
    within("ul#bot-model-#{bot.id}") do
      click_on 'Ver detalhes'
    end
    click_on 'Bloquear'

    expect(page).to have_content('Aguardando confirmação de bloqueio')
    expect(page).not_to have_content('Confirmar bloqueio')
    expect(page).not_to have_content('Bloquear')
  end

  scenario 'other user confirm block' do
    user1 = create(:user)
    user2 = create(:user)
    bot = create(:bot)

    login_as user1, scope: :user

    visit bots_path
    within("ul#bot-model-#{bot.id}") do
      click_on 'Ver detalhes'
    end
    click_on 'Bloquear'

    logout(:user)
    login_as user2, scope: :user

    visit bots_path

    within("ul#bot-model-#{bot.id}") do
      click_on 'Ver detalhes'
    end
    click_on 'Confirmar bloqueio'

    expect(page).not_to have_content('Bloquear')
    expect(page).not_to have_content('Confirmar bloqueio')
    expect(page).not_to have_content('Aguardando confirmação de bloqueio')
    expect(page).to have_content('Bloqueado')
  end

  scenario 'check bots blocked ' do
    user1 = create(:user)
    user2 = create(:user)
    company = create(:company, name: 'AzulCol')
    bot = create(:bot, company: company)
    bot2 = create(:bot, company: company)
    company2 = create(:company, name: 'REdCol')
    bot3 = create(:bot, company: company2)

    create(:block_bot, bot: bot3, created_at: Time.zone.today - 20, updated_at: Time.zone.today - 18)

    create(:block_bot, bot: bot2, created_at: Time.zone.today - 20, updated_at: Time.zone.today - 18)

    login_as user1, scope: :user

    visit bots_path
    within("ul#bot-model-#{bot.id}") do
      click_on 'Ver detalhes'
    end
    click_on 'Bloquear'

    logout(:user)
    login_as user2, scope: :user

    visit bots_path

    within("ul#bot-model-#{bot.id}") do
      click_on 'Ver detalhes'
    end
    click_on 'Confirmar bloqueio'

    expect(page).not_to have_content('Bloquear')
    expect(page).not_to have_content('Confirmar bloqueio')
    expect(page).not_to have_content('Aguardando confirmação de bloqueio')
    expect(page).to have_content('Bloqueado')
    expect(page).to have_content('Empresa bloqueada')
    expect(company.reload.blocked).to eq(true)
    expect(company2.reload.blocked).to eq(false)
  end
end
