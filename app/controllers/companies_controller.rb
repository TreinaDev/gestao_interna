class CompaniesController < ApplicationController
  def index
    @companies = Company.all
  end

  def show
    @company = Company.find(params[:id])
    @bots = Bot.company_bots(@company.id)
  end
end
