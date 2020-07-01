require 'rails_helper'

feature 'User can browse cancellation request' do
  scenario 'successfuly' do
    log_user_in!
    cancellation_request = create(:order_cancellation_request)

    visit root_path

    click_on 'Solicitações de cancelamento'

    expect(current_path).to eq(order_cancellation_requests_path)
    expect(page).to have_content(cancellation_request.id)
    expect(page).to have_content(cancellation_request.order.company.name)
    expect(page).to have_content(cancellation_request.order.company.token)
    expect(page).to have_content(cancellation_request.order.plan.name)
  end

  scenario 'and approve one successfuly' do
    user = log_user_in!
    create(:order_cancellation_request)
    cancellation_request = create(:order_cancellation_request)

    visit root_path

    click_on 'Solicitações de cancelamento'
    within "tr#request-#{cancellation_request.id}" do
      click_on 'Aprovar'
    end

    expect(cancellation_request.status).to eq('approved')
    expect(cancellation_request.user).to eq(user)

    expect(current_path).to eq(order_cancellation_requests_path)
    expect(page).to have_content('Solicitação de cancelamento aprovada!')
    expect(page).not_to have_content(cancellation_request.id)
    expect(page).not_to have_content(cancellation_request.order.company.name)
    expect(page).not_to have_content(cancellation_request.order.company.token)
    expect(page).not_to have_content(cancellation_request.order.plan.name)
  end
end