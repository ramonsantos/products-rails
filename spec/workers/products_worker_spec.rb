require 'rails_helper'

CSV_FILE = "#{Rails.root}/tmp/spec/file.csv"

RSpec.describe ProductsWorker, type: :worker do
  before(:each) do
    Mongoid::Config.purge!
    $redis.keys.each {|k| $redis.del k}
    system "curl -XDELETE localhost:9200/repository"

    File.delete(CSV_FILE) if File.exist?(CSV_FILE)
  end

  context 'export products report' do
    it 'is processing worker' do
      expect(ProductsWorker).to be_processed_in :default
    end

    it 'is generating CSV file' do
      products_db = []
      products_db << create(:valid_product_a).to_hash.except!(:id, :updated_at, :created_at)
      products_db << create(:valid_product_b).to_hash.except!(:id, :updated_at, :created_at)

      Sidekiq::Testing.disable!
      ProductsWorker.new.perform CSV_FILE

      products = CSV.read(CSV_FILE, {:col_sep => ";", :row_sep => "\n"})
        .map { |x| Product.new(name: x[0], sku: x[1], description: x[2], quantity: x[3], price: x[4], bar_code: x[5]).to_hash.except! :id, :updated_at, :created_at}

      expect(products_db[0]).to eq products[0]
      expect(products_db[1]).to eq products[1]
      expect(products_db[2]).to eq nil
    end
  end

  after(:each) do
    Sidekiq::Testing.fake!
  end
end
