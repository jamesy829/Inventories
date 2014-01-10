class ProductHistoriesController < ApplicationController
  before_filter :load_product_histories, only: [ :edit, :update ]
  before_filter :load_product

  def new
    @product_history = ProductHistory.new
  end

  def edit
  end

  def create
    @product_history = ProductHistory.new(product_history_params)

    if @product_history.save
      redirect_to @product
    else
      render 'new'
    end
  end

  def update
    if @product_history.update(product_history_params)
      redirect_to @product
    else
      render 'edit'
    end
  end

  private

  def product_history_params
    params.require(:product_history).merge('product_id' => params[:product_id])
                                    .permit(:date, :price, :count, :product_id)
  end

  def load_product_histories
    @product_history = ProductHistory.find(params[:id])
  end

  def load_product
    @product = Product.find(params[:product_id])
  end
end
