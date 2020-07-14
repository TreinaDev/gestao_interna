require 'faker'

User.create(email: 'teste@gestao.com.br', password: '123456')
User.create(email: 'teste2@gestao.com.br', password: '123456')

[
  'Plano Essencial',
  'Plano Especial',
  'Plano Ideal',
  'Plano Multi',
  'Plano top'
].map { |name| FactoryBot.create :plan, name: name }
FactoryBot.create_list :plan, 2, :inactive

FactoryBot.create_list :bot_chat, 5, bot: Bot.first
FactoryBot.create_list :bot_chat, 5, bot: Bot.last
