class Api::V1::BotUsageController < Api::V1::ApiController
  rescue_from ArgumentError, with: :invalid_params

  def generate
    @bot = Bot.find_by!(token: params[:bot][:token])
    @results = BotUsageService.call(bot: @bot, raw_date: params[:date])

    render status: :ok, json: @results
  end

  private

  def invalid_params
    render status: :unprocessable_entity, json: { error: t('.invalid_date') }
  end
end
