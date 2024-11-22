class Ethereum::Block < ApplicationRecord
  # TODO: validate that the Block was proposed by a Validator we care about

  after_create do
    Rails.logger.info "Processing new block #{number}"
  end

  def number
    Integer(number_hex)
  end
end
