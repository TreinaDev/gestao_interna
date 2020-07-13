require 'faker'

User.create(email: 'teste@gestao.com.br', password: '123456')

FactoryBot.create_list :plan, 5
FactoryBot.create_list :plan, 2, :inactive

FactoryBot.create_list :company, 5

FactoryBot.create_list :purchase, 5
FactoryBot.create_list :purchase_cancellation, 5

FactoryBot.create_list :bot, 3
FactoryBot.create_list :bot_chat, 5, bot: Bot.first
FactoryBot.create_list :bot_chat, 5, bot: Bot.last
