require 'rails_helper'

RSpec.describe Product, type: :model do
  before(:each) do
    @product = Product.new(name: "Notebook")
  end

  context "product valid" do
    it "is valid with sku alphanumeric" do
      @product.sku = "i7 8GB"

      expect(@product).to be_valid
      expect(@product.save).to be_truthy
    end

    it "it valid with name" do
      expect(@product).to be_valid
      expect(@product.save).to be_truthy
    end

    it "is valid with price greater than 0.0" do
      @product.price = 0.01

      expect(@product).to be_valid
      expect(@product.save).to be_truthy
    end

    it "is valid with bar_code numeric" do
      @product.bar_code = "12345678"
      expect(@product).to be_valid

      @product.bar_code = "1234567890123"
      expect(@product).to be_valid

      expect(@product.save).to be_truthy
    end
  end

  context "product not valid" do
    it "is not valid with sku different of alphanumeric" do
      @product.sku = "!?;**@"

      expect(@product).to_not be_valid
      expect(@product.save).to be_falsey
    end

    it "is not valid without name" do
      @product.name = nil

      expect(@product).to_not be_valid
      expect(@product.save).to be_falsey
    end

    it "is not valid with price less than or equal to 0.0" do
      @product.price = 0.0
      expect(@product).to_not be_valid
    
      @product.price = -1.0
      expect(@product).to_not be_valid
      
      expect(@product.save).to be_falsey
    end

    it "is not valid with bar_code different of numeric" do
      @product.bar_code = "i@-+2@sd"
      
      expect(@product).to_not be_valid
      expect(@product.save).to be_falsey
    end

    it "is not valid with bar_code less than 8 digits" do
      @product.bar_code = "1234567"

      expect(@product).to_not be_valid
      expect(@product.save).to be_falsey
    end

    it "is not valid with bar_code greater than 13 digits" do
      @product.bar_code = "12345678901234"

      expect(@product).to_not be_valid
      expect(@product.save).to be_falsey
    end
  end

  context "persistence of products" do
    it "save product with bar_code" do
      @product.bar_code = "1234567890"
      expect(@product.save).to be_truthy

      product_db = Product.last
      expect(@product).to eql? product_db
    end

    it "save product without bar_code" do
      @product.bar_code = nil
      expect(@product.save).to be_truthy

      product_db = Product.last
      expect(@product).to eql? product_db
    end
  end
end



