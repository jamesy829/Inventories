require 'spec_helper'

describe 'when creating a product' do
  before(:each) do
    visit new_product_path
    fill_in 'product_name',   with: name
    fill_in 'product_price',  with: price
    fill_in 'product_sku_id', with: sku_id
  end

  let(:name) { Faker::Name.name }
  let(:price) { Faker::Number.number(5) }
  let(:sku_id) { Faker::Number.number(5) }
  let(:submit) { 'Create Product' }

  describe 'with valid information' do
    it 'should redirects to product#show page' do
      expect { click_button submit }.to change(Product, :count)
      expect(page).to have_content "Name: #{name}"
    end
  end

  describe 'with invalid information' do
    describe 'when name is blank' do
      let(:name) { '' }

      it 'should return error message' do
        expect { click_button submit }.not_to change(Product, :count)
        expect(page).to have_content "Name can't be blank"
      end
    end

    describe 'when name exceed 256 characters' do
      let(:name) { '*' * 257 }

      it 'should return error message' do
        expect { click_button submit }.not_to change(Product, :count)
        expect(page).to have_content 'Name is too long (maximum is 256 characters)'
      end
    end

    describe 'when price is negative' do
      let(:price) { -1 }

      it 'should return error message' do
        expect { click_button submit }.not_to change(Product, :count)
        expect(page).to have_content 'Price must be greater than or equal to 0'
      end
    end

    describe 'when sku id is negative' do
      let(:sku_id) { -1 }

      it 'should return error message' do
        expect { click_button submit }.not_to change(Product, :count)
        expect(page).to have_content 'Sku must be greater than or equal to 0'
      end
    end

    context 'uniqueness' do
      let(:product) { @product = FactoryGirl.create(:product) }

      describe 'when name is taken' do
        let(:name) { product.name }

        it 'should return error message' do
          expect { click_button submit }.not_to change(Product, :count)
          expect(page).to have_content 'Name has already been taken'
        end
      end

      describe 'when sku id is taken' do
        let(:sku_id) { product.sku_id }

        it 'should return error message' do
          expect { click_button submit }.not_to change(Product, :count)
          expect(page).to have_content 'Sku has already been taken'
        end
      end
    end
  end 
end

describe 'when product is deleted', js: true do
  before(:each) do
    @product = FactoryGirl.create(:product)
    visit products_path
  end

  it 'should redirects to product#index and product is removed' do
    count = Product.count
    within(:xpath, "//tr[@id='#{@product.name}']") { click_link 'Delete' } 
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_no_content @product.name
    expect(Product.count).to be < count
  end
end