require 'rails_helper'

CSV_FILE_PATH = "#{Rails.root}/tmp/spec/file.csv"

RSpec.describe ProductsWorker, type: :worker do
  before(:each) do
    Product.destroy_all
    File.delete(CSV_FILE_PATH) if File.exist?(CSV_FILE_PATH)
  end

  let!(:csv_products_test) {
    CSV.read(Rails.root.join("spec", "fixtures", "products_test.csv"), {:col_sep => ";", :row_sep => "\n"})
  }

  describe 'export products report' do
    it 'is processing worker' do
      expect(ProductsWorker).to be_processed_in :default
    end

    it 'is generating CSV file' do
      create(:valid_product_a)
      create(:valid_product_b)

      Sidekiq::Testing.disable!
      ProductsWorker.new.perform CSV_FILE_PATH

      products = CSV.read(CSV_FILE_PATH, {:col_sep => ";", :row_sep => "\n"})
      expect(csv_products_test).to eq products
    end
  end

  after(:each) do
    Sidekiq::Testing.fake!
  end
end
