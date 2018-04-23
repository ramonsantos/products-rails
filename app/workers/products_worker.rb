class ProductsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default

  def perform(*args)
    products = Product.all

    csv_file_path = args[0] ||= "#{Rails.root}/tmp/products_#{Time.zone.now.to_i}.csv"

    CSV.open(csv_file_path, "wb", {col_sep: ";", row_sep: "\n"}) do |csv|
      products.each do |p|
        csv << [p.name, p.sku, p.description, p.quantity, p.price, p.bar_code]
      end
    end
  end
end
