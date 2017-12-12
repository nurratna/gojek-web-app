json.extract! order, :id, :origin, :destination, :service_type, :payment_type, :created_at, :updated_at
json_url order_url(order, format: :json)
