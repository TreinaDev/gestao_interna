class BlockBotCreator
  attr_reader :bot, :user

  NUMBER_OF_BLOCK_TO_BLOCK_COMPANY = 4

  def initialize(bot, user)
    @bot = bot
    @user = user
  end

  def call
    return if bot.canceled? || bot.blocked?

    create_bot_block
    verify_block
    verify_company_block
  end

  private

  def verify_block
    return bot.awaiting! if bot.active?

    bot.blocked!
  end

  def create_bot_block
    BlockBot.create!(bot: bot, user: user)
  end

  def verify_company_block
    return unless number_of_block_bots >= NUMBER_OF_BLOCK_TO_BLOCK_COMPANY

    bot.company.block!
  end

  def number_of_block_bots
    bot
      .company
      .block_bots
      .where(updated_at: (Time.zone.now - 30.days)..Time.zone.now)
      .count
  end
end
