require 'rails_helper'

feature 'User can reject purchase cancellation request' do
  scenario 'successfuly' do
    user = log_user_in!
    cancellation_requests = create_list(:purchase_cancellation, 3)
    cancellation_request = cancellation_requests.first

    visit root_path

    click_on 'Cancelamentos'
    within "tr#purchase_cancellation-#{cancellation_request.id}" do
      click_on 'Detalhes'
    end
    click_on 'Rejeitar'

    cancellation_request.reload
    expect(cancellation_request).to be_rejected
    expect(cancellation_request.user).to eq(user)
    expect(cancellation_request.purchase).to be_active

    expect(current_path).to eq(purchase_cancellations_path)
    expect(page).to have_content('Solicitação de cancelamento rejeitada!')
    expect(page).not_to have_content(cancellation_request.purchase.company.name)
    expect(page).not_to have_content(cancellation_request.purchase.company.token)
    expect(page).not_to have_content(cancellation_request.purchase.plan.name)
  end
end
