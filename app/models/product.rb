class Product
  include Mongoid::Document

  after_save :save_elastic_search
  after_destroy :delete_elestic_search

  field :name, type: String
  field :sku, type: String
  field :description, type: String
  field :quantity, type: Integer
  field :price, type: Float

  def save
    super

   to_redis
  end

  def update(product_params)
    super(product_params)

    to_redis
  end

  def destroy
    super

    del_redis_key
  end

  def to_redis
    $redis.set(redis_key, self.to_json)
  end

  def from_redis
    project_json = $redis.get(redis_key)

    return nil if project_json.nil?

    self.from_json project_json
  end

  def to_hash
    {
      id: self._id,
      name: self.name,
      sku: self.sku,
      description: self.description,
      quantity: self.quantity,
      price: self.price
    }
  end

  private

  def redis_key
    'product:id_' << self._id.to_s
  end

  def del_redis_key
    $redis.del(redis_key)
  end

  def save_elastic_search
    $es_repository.save self
  end

  def delete_elestic_search
    $es_repository.delete self
  end
end
