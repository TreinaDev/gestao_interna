class Plan < ApplicationRecord
  attr_accessor :price

  has_many :plan_prices, dependent: :destroy
  enum status: { active: 0, inactive: 5 }

  validates :name, :price, :platforms, :limit_daily_chat, :limit_monthly_chat,
            :limit_daily_messages, :limit_monthly_messages, presence: true
  validates :name, uniqueness: true
  validate :whether_limits_or_charges_extra
  after_save_commit :create_plan_price

  def current_price
    plan_prices.last&.value
  end

  def inactive!
    @price ||= current_price
    super
  end

  def active!
    @price ||= current_price
    super
  end

  def price_at(date)
    plan_prices.closest_to(date)&.value
  end

  private

  def whether_limits_or_charges_extra
    return if blocked_on_limit
    return if extra_message_price.present? && extra_chat_price.present?

    errors.add(:extra_message_price, :blank) if extra_message_price.blank?
    errors.add(:extra_chat_price, :blank) if extra_chat_price.blank?
  end

  def create_plan_price
    return unless price

    PlanPrice.create!(value: price, plan: self) unless current_price == price.to_f
  end
end
