class Product
  include Mongoid::Document

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

  private

  def redis_key
    'product:id_' << self._id.to_s
  end

  def del_redis_key
    $redis.del(redis_key)
  end
end