class ProductHistoriesController < ApplicationController
  def new
    @product_history = ProductHistory.new
    @product = Product.find(params[:product_id])
  end

  def edit
    @product_history = ProductHistory.find(params[:id])
    @product = Product.find(params[:product_id])
  end

  def create
    @product_history = ProductHistory.new(product_history_params)
    @product = Product.find(params[:product_id])

    if @product_history.save
      redirect_to @product
    else
      render 'new'
    end
  end

  def update
    @product_history = ProductHistory.find(params[:id])

    if @product_history.update(product_history_params)
      redirect_to @product_history
    else
      render 'edit'
    end
  end

  private

  def product_history_params
    params.require(:product_history).merge('product_id' => params[:product_id])
                                    .permit(:date, :price, :count, :product_id)
  end
end
