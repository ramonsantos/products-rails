json.extract! product, :id, :name, :sku, :description, :quantity, :price, :bar_code, :created_at, :updated_at
json.url product_url(product, format: :json)
