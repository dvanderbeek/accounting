class OnchainBilling::ContractsController < ApplicationController
  before_action :set_onchain_billing_contract, only: %i[ show edit update destroy ]

  # GET /onchain_billing/contracts or /onchain_billing/contracts.json
  def index
    @onchain_billing_contracts = OnchainBilling::Contract.all
  end

  # GET /onchain_billing/contracts/1 or /onchain_billing/contracts/1.json
  def show
  end

  # GET /onchain_billing/contracts/new
  def new
    @onchain_billing_contract = OnchainBilling::Contract.new
  end

  # GET /onchain_billing/contracts/1/edit
  def edit
  end

  # POST /onchain_billing/contracts or /onchain_billing/contracts.json
  def create
    @onchain_billing_contract = OnchainBilling::Contract.new(onchain_billing_contract_params)

    respond_to do |format|
      if @onchain_billing_contract.save
        format.html { redirect_to onchain_billing_contract_url(@onchain_billing_contract), notice: "Contract was successfully created." }
        format.json { render :show, status: :created, location: @onchain_billing_contract }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @onchain_billing_contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /onchain_billing/contracts/1 or /onchain_billing/contracts/1.json
  def update
    respond_to do |format|
      if @onchain_billing_contract.update(onchain_billing_contract_params)
        format.html { redirect_to onchain_billing_contract_url(@onchain_billing_contract), notice: "Contract was successfully updated." }
        format.json { render :show, status: :ok, location: @onchain_billing_contract }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @onchain_billing_contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /onchain_billing/contracts/1 or /onchain_billing/contracts/1.json
  def destroy
    @onchain_billing_contract.destroy!

    respond_to do |format|
      format.html { redirect_to onchain_billing_contracts_url, notice: "Contract was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_onchain_billing_contract
      @onchain_billing_contract = OnchainBilling::Contract.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def onchain_billing_contract_params
      params.require(:onchain_billing_contract).permit(:tab, :org_id)
    end
end
