json.extract! billing_price, :id, :product_id, :name, :billing_scheme, :price_per_unit_cents, :currency, :created_at, :updated_at
json.url billing_price_url(billing_price, format: :json)
