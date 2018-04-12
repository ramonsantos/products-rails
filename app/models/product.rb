class Product
  include Mongoid::Document
  field :name, type: String
  field :sku, type: String
  field :description, type: String
  field :quantity, type: Integer
  field :price, type: Float
end
