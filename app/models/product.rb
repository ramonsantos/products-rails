class Product
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :sku, type: String
  field :description, type: String
  field :quantity, type: Integer
  field :price, type: Float
  field :bar_code, type: String

  validates_presence_of :name

  after_save :save_elastic_search, :to_redis
  after_destroy :delete_elestic_search, :del_redis_key

  def to_redis
    $redis.set(Product.redis_key(self.id), JSON(self.to_hash))
  end

  def self.from_redis(id)
    product_json = $redis.get(redis_key(id))

    Product.new.from_json(product_json) unless product_json.nil?
  end

  def to_hash
    {
      id: self.id.to_s,
      name: self.name,
      sku: self.sku,
      description: self.description,
      quantity: self.quantity,
      price: self.price,
      bar_code: self.bar_code,
      created_at: self.created_at,
      updated_at: self.updated_at
    }
  end

  def self.search(search)
    $es_repository.search(
      query: {
        query_string: {
          query: ("*" << search << "*"), fields: [:name, :sku, :description]
        }
      })
  end

  private

    def self.redis_key(id)
      "product:id_#{id}"
    end

    def del_redis_key
      $redis.del(Product.redis_key(self.id))
    end

    def save_elastic_search
      $es_repository.save self
    end

    def delete_elestic_search
      $es_repository.delete self
    end
end
