class Org < ApplicationRecord
  def accounts_by_name
    @accounts_by_name ||= OpenStruct.new(
      Plutus::Account.where(tenant: self).index_by(&:name)
    )
  end
end
