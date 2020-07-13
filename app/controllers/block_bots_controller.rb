class BlockBotsController < ApplicationController
  def create
    @bot = Bot.find(params[:bot_id])
    @bot.awaiting!
    @block_bot = BlockBot.create!(bot_id: @bot.id, user: current_user)
    redirect_to @bot
  end

  def confirm
    @bot = Bot.find(params[:bot_id])
    @block_bot = BlockBot.find_by(params[@bot.id])
    @bot.blocked!
    check_company_block
    @block_bot.update(user: current_user)
    redirect_to @bot
  end

  private

  def check_company_block
    @bot.company.block_company
    flash[:notice] = 'Empresa bloqueada' if @bot.company.blocked?
  end
end
