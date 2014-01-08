class ManufacturersController < ApplicationController
  before_filter :load_manufacturer, only: [:show, :edit, :update, :destroy]

  def index
    @manufacturers = Manufacturer.all
  end

  def new
    @manufacturer = Manufacturer.new
  end

  def edit
  end

  def create
    @manufacturer = Manufacturer.new(manufacturer_params)

    if @manufacturer.save
      redirect_to @manufacturer
    else
      render 'new'
    end
  end

  def update
    if @manufacturer.update(manufacturer_params)
      redirect_to @manufacturer
    else
      render 'edit'
    end
  end

  def show
    @products = @manufacturer.products
  end

  def destroy
    @manufacturer.destroy

    redirect_to manufacturers_path
  end

  private

  def manufacturer_params
    params.require(:manufacturer).permit(:name)
  end

  def load_manufacturer
    @manufacturer = Manufacturer.includes(:products).find(params[:id])
  end
end
