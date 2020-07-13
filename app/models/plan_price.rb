class PlanPrice < ApplicationRecord
  belongs_to :plan

  validates :value, presence: true

  scope :closest_to, ->(date) { order(created_at: :desc).find_by('created_at < ?', date) }
end
