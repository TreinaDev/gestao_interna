require 'rails_helper'

feature 'User can browse purchases' do
  scenario 'successfully' do
    log_user_in!
    purchases = create_list(:purchase, 3)

    visit root_path
    click_on 'Compras'

    expect(current_path).to eq(purchases_path)
    purchases.each do |purchase|
      expect(page).to have_content(purchase.token)
      expect(page).to have_content(purchase.plan.name)
      expect(page).to have_content(purchase.company.name)
    end
    expect(page).to have_content('Ativo', count: 3)
  end

  scenario 'and view details' do
    log_user_in!
    create_list(:purchase, 2)
    plan = create(:plan, extra_message_price: 23.34, extra_chat_price: 764.23,
                         created_at: '2020-03-01 7:33')
    create(:plan_price, plan: plan, value: 137.31, created_at: '2020-03-02 7:33')
    purchase = create(:purchase, plan: plan, created_at: '2020-03-11 7:33')
    create(:plan_price, plan: plan, created_at: '2020-03-13 7:33')

    visit purchases_path
    within "tr#purchase-#{purchase.id}" do
      click_on 'Detalhes'
    end

    expect(current_path).to eq(purchase_path(purchase))
    expect(page).to have_content(purchase.token)
    expect(page).to have_content('11 de março, 07:33')
    expect(page).to have_content('Ativo')

    expect(page).to have_content(purchase.plan.name)
    expect(page).to have_content('R$ 137,31')
    expect(page).to have_content(purchase.plan.platforms)
    expect(page).to have_content(purchase.plan.limit_daily_chat)
    expect(page).to have_content(purchase.plan.limit_monthly_chat)
    expect(page).to have_content(purchase.plan.limit_daily_messages)
    expect(page).to have_content(purchase.plan.limit_monthly_messages)
    expect(page).to have_content('R$ 23,34')
    expect(page).to have_content('R$ 764,23')

    expect(page).to have_content(purchase.company.name)
    expect(page).to have_content(purchase.company.cnpj)
    expect(page).to have_content(purchase.company.token)
  end
end
