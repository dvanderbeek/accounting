class Billing::ProductsController < ApplicationController
  before_action :set_billing_product, only: %i[ show edit update destroy ]

  # GET /billing/products or /billing/products.json
  def index
    @billing_products = Billing::Product.all
  end

  # GET /billing/products/1 or /billing/products/1.json
  def show
  end

  # GET /billing/products/new
  def new
    @billing_product = Billing::Product.new
  end

  # GET /billing/products/1/edit
  def edit
  end

  # POST /billing/products or /billing/products.json
  def create
    @billing_product = Billing::Product.new(billing_product_params)

    respond_to do |format|
      if @billing_product.save
        format.html { redirect_to billing_product_url(@billing_product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @billing_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @billing_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /billing/products/1 or /billing/products/1.json
  def update
    respond_to do |format|
      if @billing_product.update(billing_product_params)
        format.html { redirect_to billing_product_url(@billing_product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @billing_product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @billing_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billing/products/1 or /billing/products/1.json
  def destroy
    @billing_product.destroy!

    respond_to do |format|
      format.html { redirect_to billing_products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billing_product
      @billing_product = Billing::Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def billing_product_params
      params.require(:billing_product).permit(:name)
    end
end
