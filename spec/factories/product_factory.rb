FactoryGirl.define do
  factory :valid_product_a, :class => Product do
    name "Notebook"
    sku "i78GB"
    description "Desc A"
    quantity 20
    price 2199.99
    bar_code "0123456789"
  end

  factory :valid_product_b, :class => Product do
    name "Livro"
    sku "1984"
    description "Desc B"
    quantity 20
    price 41.99
    bar_code "1234567890"
  end

  factory :minimal_valid_product, :class => Product do
    name "Notebook"
    sku "i78GB"
    description ""
    quantity nil
    price nil
    bar_code nil
  end
end





