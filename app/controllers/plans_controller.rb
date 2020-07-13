class PlansController < ApplicationController
  def index
    @plans = Plan.all
  end

  def show
    @plan = Plan.find(params[:id])
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)
    if @plan.save
      flash[:notice] = 'Plano criado com sucesso!'
      redirect_to @plan
    else
      render :new
    end
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def update
    @plan = Plan.find(params[:id])
    if @plan.update(plan_params)
      redirect_to @plan, success: t('flash.updated')
    else
      render :edit
    end
  end

  def deactivate
    plan = Plan.find(params[:id])
    plan.inactive!

    redirect_to plans_path, success: t('flash.plan.deactivated')
  end

  def activate
    plan = Plan.find(params[:id])
    plan.active!

    redirect_to plans_path, success: t('flash.plan.activated')
  end

  private

  def plan_params
    params.require(:plan).permit(:name, :price, :platforms,
                                 :limit_daily_chat, :limit_monthly_chat,
                                 :limit_daily_messages, :limit_monthly_messages,
                                 :extra_message_price, :extra_chat_price)
  end
end
