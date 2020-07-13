require 'rails_helper'

feature 'User edit plan prices' do
  scenario 'succesfully' do
    log_user_in!
    plan = create(:plan)

    visit root_path
    click_on 'Planos'
    within "tr#plan-#{plan.id}" do
      click_on 'Detalhes'
    end
    click_on 'Editar'
    fill_in 'Valor mensal', with: '100.00'
    click_on 'Enviar'

    expect(current_path).to eq(plan_path(plan))
    expect(page).to have_content('Atualizado com sucesso!')
    expect(page).to have_content('R$ 100,00')
  end

  scenario 'cannot be blank' do
    log_user_in!
    plan = create(:plan)

    visit edit_plan_path(plan)

    fill_in 'Valor mensal', with: ''
    fill_in 'Nome', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Valor mensal não pode ficar em branco')
    expect(page).to have_content('Nome não pode ficar em branco')
  end
end
