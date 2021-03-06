class ProductsController < ApplicationController
  def index
    @products = Product.page(params[:page])
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product
    else
      render 'new'
    end
  end

  def update
    @product = Product.find(params[:id])

    if @product.update(product_params)
      redirect_to @product
    else
      render 'edit'
    end
  end

  def show
    @product = Product.find(params[:id])
    @product_histories = @product.product_histories.order_by_date.page(params[:page])
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    url = URI(request.referrer).path ==  '/products' ? products_path : manufacturer_path(@product.manufacturer)
    redirect_to url
  end

  private
    def product_params
      params.require(:product).permit(:name, :price, :sku_id, :manufacturer_id)
    end
end
