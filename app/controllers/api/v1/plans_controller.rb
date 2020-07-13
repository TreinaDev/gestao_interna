class Api::V1::PlansController < Api::V1::ApiController
  def index
    @plans = Plan.active

    render json: @plans.to_json(methods: [:current_price])
  end

  def show
    @plan = Plan.find(params[:id])

    render json: @plan.to_json(methods: [:current_price])
  end
end
