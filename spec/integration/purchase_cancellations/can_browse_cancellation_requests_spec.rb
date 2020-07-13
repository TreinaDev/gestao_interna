feature 'User can browse purchase cancellation request' do
  scenario 'successfuly' do
    log_user_in!
    cancellation_request = create(:purchase_cancellation)
    another_cancellation_request = create(:purchase_cancellation)

    visit root_path

    click_on 'Cancelamentos'

    expect(current_path).to eq(purchase_cancellations_path)
    expect(page).to have_content(cancellation_request.id)
    expect(page).to have_content(cancellation_request.purchase.company.name)
    expect(page).to_not have_content(cancellation_request.purchase.company.token)
    expect(page).to have_content(cancellation_request.purchase.plan.name)
    expect(page).to have_content(another_cancellation_request.id)
    expect(page).to have_content(another_cancellation_request.purchase.company.name)
    expect(page).to_not have_content(another_cancellation_request.purchase.company.token)
    expect(page).to have_content(another_cancellation_request.purchase.plan.name)
  end

  scenario 'and view details' do
    log_user_in!
    cancellation_request = create(:purchase_cancellation, :with_a_reason)
    another_cancellation_request = create(:purchase_cancellation)

    visit root_path
    click_on 'Cancelamentos'
    within "tr#purchase_cancellation-#{cancellation_request.id}" do
      click_on 'Detalhes'
    end

    expect(current_path).to eq(purchase_cancellation_path(cancellation_request))
    expect(page).to have_content(cancellation_request.id)
    expect(page).to have_content(cancellation_request.purchase.company.name)
    expect(page).to have_content(cancellation_request.purchase.company.token)
    expect(page).to have_content(cancellation_request.purchase.plan.name)
    expect(page).to have_content(cancellation_request.reason)

    expect(page).to_not have_content(another_cancellation_request.purchase.company.name)
    expect(page).to_not have_content(another_cancellation_request.purchase.company.token)
    expect(page).to_not have_content(another_cancellation_request.purchase.plan.name)
  end
end
