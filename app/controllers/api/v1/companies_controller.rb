class Api::V1::CompaniesController < Api::V1::ApiController
  def create
    @company = Company.create!(company_params)

    render json: @company, status: :created
  end

  private

  def company_params
    params.require(:company).permit(:fantasy_name, :cnpj, :address,
                                    :corporate_name, :token)
  end
end
