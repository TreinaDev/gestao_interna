class Purchase < ApplicationRecord
  belongs_to :company
  belongs_to :plan

  has_one :bot, dependent: :restrict_with_error
  has_many :cancellation_requests, class_name: 'PurchaseCancellation',
                                   dependent: :destroy

  enum status: { active: 0, inactive: 5 }

  validate :whether_company_is_not_bloked
  after_commit :create_bot, on: :create
  has_secure_token

  def price_when_bought
    plan.price_at(created_at)
  end

  private

  def whether_company_is_not_bloked
    return unless company&.blocked

    errors.add :company, :blocked
  end

  def create_bot
    Bot.create!(purchase: self, company: company)
  end

  def bot_token
    bot&.token
  end
end
