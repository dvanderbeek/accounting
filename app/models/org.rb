class Org < ApplicationRecord
  def balance_owed
    @balance_owed ||= accounts_by_name.accrued_service_fees.balance
  end

  def accounts_by_name
    @accounts_by_name ||= OpenStruct.new(
      Plutus::Account.where(tenant: self).index_by(&:name)
    )
  end

  def subscription
    @subscription ||= Subscription.new(fee: 0.05)
  end
end
