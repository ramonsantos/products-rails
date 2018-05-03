class ProductsWorker
  require 'net/http'

  include Sidekiq::Worker
  sidekiq_options queue: :default

  def perform(*args)
    products = Product.all

    csv_content = CSV.generate(col_sep: ';', row_sep: "\n") do |csv|
      products.each do |p|
        csv << [p.name, p.sku, p.description, p.quantity, p.price, p.bar_code]
      end
    end

    csv_file_path = args[0] ||= "#{Rails.root}/tmp/products_#{Time.zone.now.to_i}.csv"
    File.write(csv_file_path, csv_content)

    begin
      uri = URI('http://localhost:4000/api/report/')
      Net::HTTP.post_form(uri, content: csv_content)
    rescue StandardError
      puts 'Erro no Serviço'
    end
  end
end
