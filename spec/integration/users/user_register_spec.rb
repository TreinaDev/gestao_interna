require 'rails_helper'

feature 'User register account' do
  scenario 'successfully' do
    visit root_path
    click_on 'Registrar Usuário'

    fill_in 'Email', with: 'user@test.com'
    fill_in 'Senha', with: '12345678'
    fill_in 'Confirmação de senha', with: '12345678'

    click_on 'Registrar-se'

    expect(current_path).to eq root_path
    expect(page).to have_content('Login efetuado com sucesso')
  end

  scenario 'invalid email' do
    visit new_user_registration_path

    fill_in 'Email', with: 'user.com'
    fill_in 'Senha', with: '12345678'
    fill_in 'Confirmação de senha', with: '12345678'

    click_on 'Registrar-se'

    expect(User.count).to eq 0
    expect(page).to have_content('Email não é válido')
  end

  scenario 'invalid password' do
    visit new_user_registration_path

    fill_in 'Email', with: 'user@test.com'
    fill_in 'Senha', with: '12345679'
    fill_in 'Confirmação de senha', with: '12345678'

    click_on 'Registrar-se'

    expect(User.count).to eq 0
    expect(page).to have_content('Confirmação de senha não é igual a Senha')
  end

  scenario 'short password' do
    visit new_user_registration_path

    fill_in 'Email', with: 'user@test.com'
    fill_in 'Senha', with: '123'
    fill_in 'Confirmação de senha', with: '123'

    click_on 'Registrar-se'

    expect(User.count).to eq 0
    expect(page).to have_content('Senha é muito curto (mínimo: 6 caracteres)')
  end

  scenario 'email cannot be blank' do
    visit new_user_registration_path

    fill_in 'Email', with: ''
    fill_in 'Senha', with: '12345678'
    fill_in 'Confirmação de senha', with: '123'

    click_on 'Registrar-se'

    expect(User.count).to eq 0
    expect(page).to have_content('Email não pode ficar em branco')
  end

  scenario 'senha cannot be blank' do
    visit new_user_registration_path

    fill_in 'Email', with: 'user@test.com'
    fill_in 'Senha', with: ''
    fill_in 'Confirmação de senha', with: '123'

    click_on 'Registrar-se'

    expect(User.count).to eq 0
    expect(page).to have_content('Senha não pode ficar em branco')
  end
end
