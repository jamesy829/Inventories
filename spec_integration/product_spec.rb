require 'spec_helper'

describe 'when creating a product' do

  let!(:manufacturer) { FactoryGirl.create(:manufacturer) }

  before(:each) do
    visit new_product_path
    fill_in 'product_name',   with: name
    fill_in 'product_price',  with: price
    fill_in 'product_sku_id', with: sku_id
    select manufacturer.name, from: 'product_manufacturer_id'
  end

  after(:all) { manufacturer.destroy }

  let(:name) { Faker::Name.name }
  let(:price) { Faker::Number.number(5) }
  let(:sku_id) { Faker::Number.number(5) }
  let(:submit) { 'Save' }

  describe 'with valid information' do
    it 'should redirects to product#show page' do
      expect { click_button submit }.to change(Product, :count)
      expect(page).to have_content name
    end
  end

  describe 'with invalid information' do
    describe 'when name is blank' do
      let(:name) { '' }

      it 'should return error message' do
        expect { click_button submit }.not_to change(Product, :count)
        error = page.has_selector?(:xpath,
                                   "//input[@id='product_name']/../span[text()=\"can't be blank\"]")
        expect(error).to be_true
      end
    end

    describe 'when name exceed 256 characters' do
      let(:name) { '*' * 257 }

      it 'should return error message' do
        expect { click_button submit }.not_to change(Product, :count)
        error = page.has_selector?(:xpath,
                                   "//input[@id='product_name']/../span[text()='is too long (maximum is 256 characters)']")
        expect(error).to be_true
      end
    end

    describe 'when price is blank' do
      let(:price) { '' }

      it 'should return error message' do
        expect { click_button submit }.not_to change(Product, :count)
        error = page.has_selector?(:xpath,
                                   "//input[@id='product_price']/../span[contains(.,\"can't be blank\")]")
        expect(error).to be_true
      end
    end

    describe 'when price is negative' do
      let(:price) { -1 }

      it 'should return error message' do
        expect { click_button submit }.not_to change(Product, :count)
        error = page.has_selector?(:xpath,
                                   "//input[@id='product_price']/../span[text()='must be greater than or equal to 0']")
        expect(error).to be_true
      end
    end

    describe 'when sku id is negative' do
      let(:sku_id) { -1 }

      it 'should return error message' do
        expect { click_button submit }.not_to change(Product, :count)
        error = page.has_selector?(:xpath,
                                   "//input[@id='product_sku_id']/../span[text()='must be greater than or equal to 0']")
        expect(error).to be_true
      end
    end

    context 'uniqueness' do
      let(:product) { @product = FactoryGirl.create(:product) }

      describe 'when name is taken' do
        let(:name) { product.name }

        it 'should return error message' do
          expect { click_button submit }.not_to change(Product, :count)
          error = page.has_selector?(:xpath,
                                   "//input[@id='product_name']/../span[text()='has already been taken']")
          expect(error).to be_true
        end
      end

      describe 'when sku id is taken' do
        let(:sku_id) { product.sku_id }

        it 'should return error message' do
          expect { click_button submit }.not_to change(Product, :count)
          error = page.has_selector?(:xpath,
                                   "//input[@id='product_sku_id']/../span[text()='has already been taken']")
          expect(error).to be_true
        end
      end
    end
  end 
end

describe 'when product is deleted', js: true do
  before(:each) do
    @product = FactoryGirl.create(:product)
    visit manufacturer_path(@product.manufacturer)
  end

  it 'should redirects to manufacturer and product is removed' do
    count = Product.count
    within(:xpath, "//tr[@id='#{@product.name}']") { click_link 'Delete' } 
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_no_content @product.name
    expect(Product.count).to be < count
  end
end

describe 'when product is viewed' do
  before(:each) do
    @product = FactoryGirl.create(:product)
    visit product_path(@product)
  end

  it 'should redirect to manufacturer' do
    click_link 'Back'
    find('h1').should have_content @product.manufacturer.name
  end
end

describe 'pagination' do
  before(:each) { FactoryGirl.create_list(:product, 30, manufacturer: manufacturer) }

  let(:manufacturer) { FactoryGirl.create(:manufacturer) }

  context 'on first page' do
    before(:each) { visit manufacturer_path(manufacturer) }

    it 'previous button is disabled' do
      page.has_selector?(:xpath, "//ul[contains(@class,'pager')]//li[@class='previous disabled']") == true
    end

    it 'clicking next should go back next page', js: true do
      html = page.html
      click_link 'Next'
      wait_for_ajax
      page.html.should_not == html
    end
  end

  context 'on last page' do
    before(:each) { visit "#{manufacturer_path(manufacturer)}?page=3" }

    it 'next button is disabled' do
      page.has_selector?(:xpath, "//ul[contains(@class,'pager')]//li[@class='next disabled']") == true
    end

    it 'clicking back should go back on previous page', js: true do
      html = page.html
      click_link 'Previous'
      wait_for_ajax
      page.html.should_not == html
    end
  end
end