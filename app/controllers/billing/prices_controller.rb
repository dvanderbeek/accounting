class Billing::PricesController < ApplicationController
  before_action :set_billing_price, only: %i[ show edit update destroy ]

  # GET /billing/prices or /billing/prices.json
  def index
    @billing_prices = Billing::Price.all
  end

  # GET /billing/prices/1 or /billing/prices/1.json
  def show
  end

  # GET /billing/prices/new
  def new
    @billing_price = Billing::Price.new
  end

  # GET /billing/prices/1/edit
  def edit
  end

  # POST /billing/prices or /billing/prices.json
  def create
    @billing_price = Billing::Price.new(billing_price_params)

    respond_to do |format|
      if @billing_price.save
        format.html { redirect_to billing_price_url(@billing_price), notice: "Price was successfully created." }
        format.json { render :show, status: :created, location: @billing_price }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @billing_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /billing/prices/1 or /billing/prices/1.json
  def update
    respond_to do |format|
      if @billing_price.update(billing_price_params)
        format.html { redirect_to billing_price_url(@billing_price), notice: "Price was successfully updated." }
        format.json { render :show, status: :ok, location: @billing_price }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @billing_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billing/prices/1 or /billing/prices/1.json
  def destroy
    @billing_price.destroy!

    respond_to do |format|
      format.html { redirect_to billing_prices_url, notice: "Price was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billing_price
      @billing_price = Billing::Price.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def billing_price_params
      params.require(:billing_price).permit(:product_id, :name, :billing_scheme, :price_per_unit_cents, :currency)
    end
end
