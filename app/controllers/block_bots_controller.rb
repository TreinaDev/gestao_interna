class BlockBotsController < ApplicationController
  def create
    @bot = Bot.find(params[:bot_id])
    BlockBotCreator.new(@bot, current_user).call
    redirect_to @bot
  end

  def confirm
    @bot = Bot.find(params[:bot_id])
    BlockBotCreator.new(@bot, current_user).call
    flash[:notice] = 'Empresa bloqueada' if @bot.company.blocked?
    redirect_to @bot
  end
end
