class ProductHistoriesController < ApplicationController
  def new
    @product_history = ProductHistory.new
  end

  def edit
    @product_history = ProductHistory.find(params[:id])
  end

  def create
    @product_history = ProductHistory.new(product_history_params)

    if @product_history.save
      redirect_to @product_history
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
    params.require(:product_history).permit(:date, :price, :count)
  end
end
