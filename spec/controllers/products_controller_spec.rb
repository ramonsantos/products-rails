require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:valid_attributes) do
    { name: 'Notebook', sku: 'i7-8gb' }
  end

  let(:invalid_attributes) do
    { name: nil, sku: nil }
  end

  before(:each) do
    Product.destroy_all
  end

  describe 'GET #index' do
    context 'with all products' do
      it 'returns a success response' do
        get :index
        expect(response).to be_success
      end
    end

    context 'with products by search' do
      it 'product found' do
        create(:valid_product_a)

        get :index, search: 'note'
        expect(assigns(:products).size).to eq(1)
      end

      it 'product not found' do
        create(:valid_product_a)

        get :index, search: 'livw'

        expect(assigns(:products).size).to eq(0)
      end
    end
  end

  describe 'GET #report' do
    context 'controller workflow' do
      before(:each) do
        get :report
      end

      it 'returns a redirect response' do
        expect(response).to redirect_to(products_path)
      end

      it 'shows flash notice' do
        expect(flash[:notice]).to match(/relatório será gerado e enviado/)
      end
    end

    context 'job execution' do
      it 'calls perform_async' do
        expect do
          get :report
        end.to change(ProductsWorker.jobs, :size).by(1)
      end
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      product = Product.create! valid_attributes

      get :show, id: product.to_param
      expect(response).to be_success
    end

    it 'returns a success response without Redis key' do
      product = Product.create! valid_attributes
      $redis.del("product:id_#{product.id}")

      get :show, id: product.to_param
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_success
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      product = Product.create! valid_attributes
      get :edit, id: product.to_param
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Product' do
        expect do
          post :create, product: valid_attributes
        end.to change(Product, :count).by(1)
      end

      it 'redirects to the created product' do
        post :create, product: valid_attributes
        expect(response).to redirect_to(Product.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, product: invalid_attributes
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { name: 'Telefone', sku: 'motoG' }
      end

      it 'updates the requested product' do
        product = Product.create! valid_attributes
        expect do
          put :update, id: product.to_param, product: new_attributes
        end.to change(Product, :count).by(0)
      end

      it 'redirects to the product' do
        product = Product.create! valid_attributes
        put :update, id: product.to_param, product: valid_attributes
        expect(response).to redirect_to(product_path)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        product = Product.create! valid_attributes
        put :update, id: product.to_param, product: invalid_attributes
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested product' do
      product = Product.create! valid_attributes
      expect do
        delete :destroy, id: product.to_param
      end.to change(Product, :count).by(-1)
    end

    it 'redirects to the products list' do
      product = Product.create! valid_attributes
      delete :destroy, id: product.to_param
      expect(response).to redirect_to(products_path)
    end
  end
end
