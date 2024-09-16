class Billing::SubscriptionsController < ApplicationController
  before_action :set_billing_subscription, only: %i[ show edit update destroy ]

  # GET /billing/subscriptions or /billing/subscriptions.json
  def index
    @billing_subscriptions = Billing::Subscription.all
  end

  # GET /billing/subscriptions/1 or /billing/subscriptions/1.json
  def show
  end

  # GET /billing/subscriptions/new
  def new
    @billing_subscription = Billing::Subscription.new
  end

  # GET /billing/subscriptions/1/edit
  def edit
  end

  # POST /billing/subscriptions or /billing/subscriptions.json
  def create
    @billing_subscription = Billing::Subscription.new(billing_subscription_params)

    respond_to do |format|
      if @billing_subscription.save
        format.html { redirect_to billing_subscription_url(@billing_subscription), notice: "Subscription was successfully created." }
        format.json { render :show, status: :created, location: @billing_subscription }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @billing_subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /billing/subscriptions/1 or /billing/subscriptions/1.json
  def update
    respond_to do |format|
      if @billing_subscription.update(billing_subscription_params)
        format.html { redirect_to billing_subscription_url(@billing_subscription), notice: "Subscription was successfully updated." }
        format.json { render :show, status: :ok, location: @billing_subscription }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @billing_subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billing/subscriptions/1 or /billing/subscriptions/1.json
  def destroy
    @billing_subscription.destroy!

    respond_to do |format|
      format.html { redirect_to billing_subscriptions_url, notice: "Subscription was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billing_subscription
      @billing_subscription = Billing::Subscription.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def billing_subscription_params
      params.require(:billing_subscription).permit(:org_id, :price_id)
    end
end
