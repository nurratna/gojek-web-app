json.extract! user, :id, :name, :email, :phone, :password, :password_confirmation, :gopay, :created_at, :updated_at
json.url user_url(user, format: :json)
