module Ethereum
  module Blocks
    class Index
      include ActiveModel::Model

      attr_accessor :id

      def call
        puts "Processing block #{block.number} for validator #{block.validator.pubkey}"
        # At this point we know it was a validator we care about.
        # Trace the reward:
        #   OCB + MEV - look for transfer to OCB contract (from beacon fee_recipient, possibly with intermediate xfers)
        #   OCB + Coinbase - beacon fee_recipient should equal OCB contract
        #   Non-OCB + MEV - look for transfer to net_fee_payout_address (from beacon fee_recipient, possibly with intermediate xfers)
        #   Non-OCB + Coinbase - beacon fee_recipient should equal net_fee_payout_address

        # Check that the beacon_block fee_recipient lines up
        paid_to = block.validator.onchain_billing_contract.present? ? org.accounts_by_name.ocb_eth : org.accounts_by_name.rewards
        # TODO: Associate accounts with onchain address

        Reward.create!(
          amount: balance_change.to_i,
          paid_to:,
          subscription: org.subscription,
          org:,
          date: block.beacon_block.block_time,
          coinbase: true
        )
      end

      private

      def block
        @block ||= Ethereum::Block.find(id)
      end

      def org
        @org ||= Org.find_by(name: block.validator.pubkey)
      end

      def balance_change
        # TODO: Factor in transfers to figure out coinbase amount
        balance(block.number) - balance(block.number - 1)
      end

      def balance(block_number)
        BeaconChain::Block.balance(block.beacon_block.fee_recipient, block_number, block.network)
      end
    end
  end
end
