class Purchase < ApplicationRecord
  belongs_to :company
  belongs_to :plan

  has_many :bots, dependent: :restrict_with_error
  has_many :cancellation_requests, class_name: 'PurchaseCancellation',
                                   dependent: :destroy

  enum status: { active: 0, inactive: 5 }

  validate :whether_company_is_not_bloked
  before_create :generate_token
  after_commit :create_bot, on: :create

  def price_when_bought
    plan.price_at(created_at)
  end

  private

  def whether_company_is_not_bloked
    return unless company&.blocked

    errors.add :company, :blocked
  end

  def generate_token
    self.token = loop do
      token = SecureRandom.alphanumeric(6).upcase
      break token unless Purchase.exists?(token: token)
    end
  end

  def create_bot
    Bot.create!(purchase: self, company: company)
  end
end
