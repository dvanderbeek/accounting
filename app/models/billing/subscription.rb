class Billing::Subscription < ApplicationRecord
  belongs_to :org
  belongs_to :price

  delegate :fee, to: :price
end
