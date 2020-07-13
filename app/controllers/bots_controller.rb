class BotsController < ApplicationController
  def index
    @bots = Bot.all
  end

  def show
    @bot = Bot.find(params[:id])
    @block_bot = BlockBot.find_by(params[:bot_id])
  end
end
