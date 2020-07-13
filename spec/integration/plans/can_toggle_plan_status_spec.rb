require 'rails_helper'

feature 'User can' do
  scenario 'deactivate a plan successfully' do
    log_user_in!
    plan = create(:plan)

    visit plans_path
    within "tr#plan-#{plan.id}" do
      click_on 'Detalhes'
    end
    click_on 'Desativar'

    expect(Plan.first).to be_inactive
    expect(current_path).to eq(plans_path)
    expect(page).to have_content('Plano desativado com sucesso!')
    expect(page).to have_content('Inativo')
  end

  scenario 'active a plan successfully' do
    log_user_in!
    plan = create(:plan, :inactive)

    visit plans_path
    within "tr#plan-#{plan.id}" do
      click_on 'Detalhes'
    end
    click_on 'Ativar'

    expect(Plan.first).to be_active
    expect(current_path).to eq(plans_path)
    expect(page).to have_content('Plano ativado com sucesso!')
    expect(page).to have_content('Ativo')
  end
end
