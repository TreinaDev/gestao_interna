class BotChat < ApplicationRecord
  belongs_to :bot

  validates :external_token, :start_time, :platform, :bot, presence: true
  validates :external_token, uniqueness: true
  validate :whether_it_starts_in_the_past
  validate :whether_it_ends_after_it_starts

  scope :between, ->(start_date, end_date) { where('created_at >= ? AND created_at <= ?', start_date, end_date) }

  private

  def whether_it_starts_in_the_past
    return if start_time_in_the_past?

    errors.add :start_time, :in_the_future
  end

  def start_time_in_the_past?
    start_time && start_time <= Time.zone.now
  end

  def whether_it_ends_after_it_starts
    return unless start_time && end_time
    return if end_time_after_start_time?

    errors.add :end_time, :before_start_time
  end

  def end_time_after_start_time?
    end_time > start_time
  end
end
