class PurchaseCancellationsController < ApplicationController
  def index
    @purchase_cancellations = PurchaseCancellation.all
  end

  def show
    @purchase_cancellation = PurchaseCancellation.find(params[:id])
  end

  def approve
    purchase_cancellation = PurchaseCancellation.find(params[:id])
    purchase_cancellation.approve!(current_user)
    purchase_cancellation.save

    redirect_to purchase_cancellations_path,
                success: t('flash.purchase_cancellation.approved')
  end

  def reject
    purchase_cancellation = PurchaseCancellation.find(params[:id])
    purchase_cancellation.reject!(current_user)
    purchase_cancellation.save

    redirect_to purchase_cancellations_path,
                success: t('flash.purchase_cancellation.rejected')
  end
end
