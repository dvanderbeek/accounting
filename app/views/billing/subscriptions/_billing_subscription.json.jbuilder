json.extract! billing_subscription, :id, :org_id, :price_id, :created_at, :updated_at
json.url billing_subscription_url(billing_subscription, format: :json)
