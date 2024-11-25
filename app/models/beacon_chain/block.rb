class BeaconChain::Block < SimpleDelegator
  def self.retrieve(slot, network)
    new(get(network, "eth/v2/beacon/blocks/#{slot}"))
  end

  def self.reward(slot, network)
    new(get(network, "eth/v1/beacon/rewards/blocks/#{slot}"))
  end

  def self.balance(address, block, network)
    Integer connection(network).post(nil, { jsonrpc: '2.0', id: 1, method: 'eth_getBalance', params: [address, block] }).body[:result]
  end

  def total
    dig(:data, :total)
  end

  def self.get(network, path, query = {})
    connection(network).get(path, query).body
  end

  def self.connection(network)
    @connection ||= Faraday.new(url: Rails.application.credentials.ethereum_holesky_rpc_url, headers: { 'Content-Type': 'application/json' }) do |f|
      f.request :json, parser_options: { array_indices: false }
      f.response :json, parser_options: { symbolize_names: true }
    end
  end

  def block_time
    dig(:data, :message, :body, :execution_payload, :timestamp).to_i
  end

  def validator_index
    dig(:data, :message, :proposer_index)
  end

  def block_number
    dig(:data, :message, :body, :execution_payload, :block_number).to_i
  end

  def fee_recipient
    dig(:data, :message, :body, :execution_payload, :fee_recipient)
  end

  def slot
    dig(:data, :message, :slot)&.to_i
  end

  def not_found?
    key?(:code) && self[:code] == 404
  end

  def finalized?
    key?(:finalized) && self[:finalized]
  end
end
