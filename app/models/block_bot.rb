class BlockBot < ApplicationRecord
  belongs_to :bot
  belongs_to :user
end
