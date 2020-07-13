class BotUsageService
  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @bot = params[:bot]
    throw ArgumentError unless @bot

    @start_date = parse_date(params[:raw_date])
    @end_date = @start_date.end_of_month
    @plan = @bot.purchase.plan
    @bot_chats = @bot.chats.between(@start_date, @end_date)
  end

  def call
    throw ArgumentError unless @bot
    throw ArgumentError if invalid_date

    generate
  end

  private

  def parse_date(raw_date)
    raw_date ? Date.parse(raw_date).beginning_of_month : Time.zone.today
  end

  def invalid_date
    @start_date < @bot.created_at
  end

  def generate
    {
      month: month,
      total_chats: total_chats,
      total_messages: total_messages,
      monthly_cost: monthly_cost
    }
  end

  def month
    @start_date.strftime('%Y-%m')
  end

  def total_chats
    @bot_chats.count
  end

  def total_messages
    @bot_chats.pluck(:message_count).inject(0, :+)
  end

  def monthly_cost
    base_cost = @bot.purchase.price_when_bought
    return base_cost if @bot.purchase.plan.blocked_on_limit

    base_cost += extra_chats_cost if exceeded_chat_limit
    base_cost += extra_messages_cost if exceeded_message_limit

    base_cost
  end

  def extra_chats_cost
    (total_chats - chat_limit) * @plan.extra_chat_price
  end

  def extra_messages_cost
    (total_messages - message_limit) * @plan.extra_message_price
  end

  def exceeded_chat_limit
    total_chats > chat_limit
  end

  def exceeded_message_limit
    total_messages > message_limit
  end

  def chat_limit
    @plan.limit_monthly_chat
  end

  def message_limit
    @plan.limit_monthly_messages
  end
end
