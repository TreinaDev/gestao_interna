class Plan < ApplicationRecord
  validates :price, :platforms, :limit_daily_chat, :limit_monthly_chat,
            :limit_daily_messages, :limit_monthly_messages,
            :extra_message_price, :extra_chat_price, presence: true

  validates :name, presence: true, uniqueness: true
end
