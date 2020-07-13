class Company < ApplicationRecord
  has_many :bots, dependent: :destroy
  has_many :block_bots, through: :bots
  validates :name, :address, :corporate_name, :cnpj, presence: true
  validates :token, uniqueness: true
  validates :cnpj, uniqueness: true, case_sensitive: false
  validates :cnpj, format: { with: %r{\A^\d{2,3}\.\d{3}\.\d{3}/\d{4}-\d{2}$\z} }
  validate :cnpj_must_be_valid

  before_create :generate_token

  def block!
    update(blocked: true)
    bots.update(status: :blocked)
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
end
