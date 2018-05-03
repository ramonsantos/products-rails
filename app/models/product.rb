class Product
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :sku, type: String
  field :description, type: String
  field :quantity, type: Integer
  field :price, type: Float
  field :bar_code, type: String

  validates_presence_of :name, :sku
  validates_length_of :bar_code, in: 8..13, allow_blank: true
  validates_numericality_of :price, only_float: true, allow_nil: true, greater_than: 0.0
  validates_format_of :sku, with: /\A[A-Za-z0-9\-]+\Z/
  validates_format_of :bar_code, allow_blank: true, with: /\A[0-9]+\Z/

  after_save :save_elastic_search, :to_redis
  after_destroy :delete_elestic_search, :del_redis_key

  def to_redis
    $redis.set(Product.redis_key(id), JSON(to_hash))
  end

  def self.from_redis(id)
    product_json = $redis.get(redis_key(id))

    Product.new.from_json(product_json) unless product_json.nil?
  end

  def to_hash
    {
      id: id.to_s,
      name: name,
      sku: sku,
      description: description,
      quantity: quantity,
      price: price,
      bar_code: bar_code,
      created_at: created_at,
      updated_at: updated_at
    }
  end

  def self.search(search)
    $es_repository.search(
      query: {
        query_string: {
          query: "*#{search}*", fields: [:name, :sku, :description]
        }
      }
    )
  end

  private

  def self.redis_key(id)
    "product:id_#{id}"
  end

  def del_redis_key
    $redis.del(Product.redis_key(id))
  end

  def save_elastic_search
    $es_repository.save self
  end

  def delete_elestic_search
    $es_repository.delete self
  end
end
