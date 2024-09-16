json.extract! billing_product, :id, :name, :created_at, :updated_at
json.url billing_product_url(billing_product, format: :json)
