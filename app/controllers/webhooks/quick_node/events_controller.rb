module Webhooks
  module QuickNode
    class EventsController < ApplicationController
      skip_forgery_protection
      # TODO: verify webhook signature

      def create
        Ethereum::Block.find_or_create_by(number_hex: params[:_json][0][:blockNumber], network: 'holesky')
        head :ok
      end
    end
  end
end
