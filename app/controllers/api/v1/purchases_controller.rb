class Api::V1::PurchasesController < Api::V1::ApiController
  before_action :check_params, :check_company, :check_plan

  def create
    @purchase = Purchase.create!(company: @company, plan: @plan, price: @price)
    render json: @purchase, include: %i[company plan], status: :ok
  end

  private

  def check_params
    return if params[:purchase] && params[:purchase][:plan_id] && params[:purchase][:company_token]

    render status: :bad_request, json: { error: t('.bad_request') }
  end

  def check_company
    @company = Company.find_by!(token: params[:purchase][:company_token])
  end

  def check_plan
    @plan = Plan.find(params[:purchase][:plan_id])
    @price = params[:purchase][:price] || @plan.current_price
  end
end
