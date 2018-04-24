require 'rails_helper'

CSV_FILE = "#{Rails.root}/tmp/spec/file.csv"

RSpec.describe ProductsWorker, type: :worker do
  before(:each) do
    Product.destroy_all
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

      expect(products_db).to eq products
    end
  end

  after(:each) do
    Sidekiq::Testing.fake!
  end

  after(:all) do
    Product.destroy_all
  end
end
