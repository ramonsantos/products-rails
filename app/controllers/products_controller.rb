class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit]
  before_action :find_product, only: [:update, :destroy]

  # GET /products
  # GET /products.json
  def index
    if params[:search].present?
      @products = Product.search(params[:search])
    else
      @products = Product.all
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save

        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)

        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /report
  def report
    ProductsWorker.perform_async

    respond_to do |format|
      format.html { redirect_to products_url, notice: 'O relatório será gerado.' }
    end
  end

  private

  def find_product
    @product = Product.find(params[:id])
  end

  def set_product
    @product = Product.from_redis(params[:id])

    if @product.nil?
      @product = Product.find(params[:id])
      @product.to_redis
    end
  end

  def product_params
    params.require(:product).permit(:name, :sku, :description, :quantity, :price, :bar_code)
  end
end
