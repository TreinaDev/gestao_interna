class Company < ApplicationRecord
  has_many :bots, dependent: :destroy
  has_many :block_bots, through: :bots
  validates :name, :address, :corporate_name, :cnpj, presence: true
  validates :token, uniqueness: true
  validates :cnpj, uniqueness: true, case_sensitive: false
  validates :cnpj, format: { with: %r{\A^\d{2,3}\.\d{3}\.\d{3}/\d{4}-\d{2}$\z} }
  validate :cnpj_must_be_valid

  before_create :generate_token

  def block_company
    update(blocked: true) if more_than_one_block_bot?
  end

  private

  def cnpj_must_be_valid
    return if CNPJ.valid?(cnpj, strict: true)

    errors.add(:cnpj, :invalid)
  end

  def generate_token
    self.token = loop do
      token = SecureRandom.alphanumeric(6).upcase
      break token unless Company.exists?(token: token)
    end
  end

  def number_of_block_bots
    block_bots.where(updated_at: (Time.zone.now - 30.days)..Time.zone.now).count
  end

  def more_than_one_block_bot?
    number_of_block_bots > 1
  end
end
