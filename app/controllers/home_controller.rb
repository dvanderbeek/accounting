class HomeController < ApplicationController
  def index
    @org = Org.first
    @statement = Statement.new(
      start_date: Date.current.beginning_of_month,
      end_date: Date.current.end_of_month,
      org: @org
    )
    @ocb_contract = OnchainBilling::Contract.find_by(org: @org)
  end
end
