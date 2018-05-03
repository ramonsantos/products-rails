require 'rails_helper'

RSpec.describe Product, type: :model do
  before(:each) do
    Product.destroy_all

    @product = build(:minimal_valid_product)
  end

  context 'product valid' do
    it 'is valid with name and sku' do
      expect(@product).to be_valid
      expect(@product.save).to be_truthy
    end

    it 'is valid with price greater than 0.0' do
      @product.price = 0.01

      expect(@product).to be_valid
      expect(@product.save).to be_truthy
    end

    it 'is valid with bar_code numeric' do
      @product.bar_code = '12345678'
      expect(@product).to be_valid

      @product.bar_code = '1234567890123'
      expect(@product).to be_valid

      expect(@product.save).to be_truthy
    end
  end

  context 'product not valid' do
    it 'is not valid with sku different of alphanumeric' do
      @product.sku = '!?;*-+*@'

      expect(@product).to_not be_valid
      expect(@product.save).to be_falsey
    end

    it 'is not valid without name' do
      @product.name = nil

      expect(@product).to_not be_valid
      expect(@product.save).to be_falsey
    end

    it 'is not valid without sku' do
      @product.sku = nil

      expect(@product).to_not be_valid
      expect(@product.save).to be_falsey
    end

    it 'is not valid with price less than or equal to 0.0' do
      @product.price = 0.0
      expect(@product).to_not be_valid

      @product.price = -1.0
      expect(@product).to_not be_valid

      expect(@product.save).to be_falsey
    end

    it 'is not valid with bar_code different of numeric string' do
      @product.bar_code = '!@#asrtdgg'

      expect(@product).to_not be_valid
      expect(@product.save).to be_falsey
    end

    it 'is not valid with bar_code less than 8 digits' do
      @product.bar_code = '1234567'

      expect(@product).to_not be_valid
      expect(@product.save).to be_falsey
    end

    it 'is not valid with bar_code greater than 13 digits' do
      @product.bar_code = '12345678901234'

      expect(@product).to_not be_valid
      expect(@product.save).to be_falsey
    end
  end

  context 'persistence of products' do
    it 'save product with bar_code' do
      @product.bar_code = '1234567890'
      expect(@product.save).to be_truthy

      product_db = Product.last
      expect(@product).to eq product_db
    end

    it 'save product without bar_code' do
      @product.bar_code = nil
      expect(@product.save).to be_truthy

      product_db = Product.last
      expect(@product).to eq product_db
    end
  end
end
