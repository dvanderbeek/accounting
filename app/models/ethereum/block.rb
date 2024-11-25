class Ethereum::Block < ApplicationRecord
  after_create do
    update(number: beacon_block.block_number) if number_hex.nil?
    # This would probably be a background job
    Ethereum::Blocks::Index.call(id) if validator.present?

    # Also look for any payouts from OCB contract and track FeePayments and OcbPayouts; this can happen even if the block
    # was proposed by another validator (for example, if we did a sweep, or really any transfer went to one of the contracts)
    Rails.logger.info "Parsing OCB Payouts for block #{number}"
  end

  def number=(int)
    self.number_hex = "0x#{int.to_s(16)}"
  end

  def number
    Integer(number_hex)
  end

  # TODO: Add association; set validator before creating the record
  def validator
    @validator ||= Ethereum::Validator.find_by(network:, onchain_index: beacon_block.validator_index)
  end

  def beacon_block
    @beacon_block ||= BeaconChain::Block.retrieve(slot, network)
  end
end
