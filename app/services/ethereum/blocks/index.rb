module Ethereum
  module Blocks
    class Index
      def self.call(id)
        block = Ethereum::Block.find(id)
        Rails.logger.info "Processing new block #{block.number} for validator #{block.validator.pubkey}"
        # At this point we know it was a validator we care about.
        # Trace the reward:
        #   OCB + MEV - look for transfer to OCB contract (from beacon fee_recipient, possibly with intermediate xfers)
        #   OCB + Coinbase - beacon fee_recipient should equal OCB contract
        #   Non-OCB + MEV - look for transfer to net_fee_payout_address (from beacon fee_recipient, possibly with intermediate xfers)
        #   Non-OCB + Coinbase - beacon fee_recipient should equal net_fee_payout_address

        # TODO: Factor in transfers to figure out coinbase amount
        amount = BeaconChain::Block.balance(block.beacon_block.fee_recipient, block.number, block.network) - BeaconChain::Block.balance(block.beacon_block.fee_recipient, block.number - 1, block.network)
        org = Org.find_by(name: block.validator.pubkey)
        subscription = org.subscription
        # Check that the beacon_block fee_recipient lines up
        paid_to = block.validator.onchain_billing_contract.present? ? org.accounts_by_name.ocb_eth : org.accounts_by_name.rewards
        date = Time.zone.at(block.beacon_block.block_time)

        Reward.create!(amount: amount.to_i, paid_to:, subscription:, org:, date:, coinbase: true)
      end
    end
  end
end
