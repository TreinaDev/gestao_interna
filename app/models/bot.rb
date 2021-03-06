class Bot < ApplicationRecord
  belongs_to :company
  belongs_to :purchase
  has_many :block_bots, dependent: :destroy
  enum status: { active: 0, awaiting: 2, canceled: 5, blocked: 10 }
  has_many :chats, class_name: 'BotChat', dependent: :restrict_with_error

  scope :company_bots, ->(company_id) { where('company_id = ?', company_id) }

  validates :token, uniqueness: true
  before_create :generate_token

  private

  def generate_token
    self.token = loop do
      token = SecureRandom.alphanumeric(6).upcase
      break token unless Bot.exists?(token: token)
    end
  end
end
