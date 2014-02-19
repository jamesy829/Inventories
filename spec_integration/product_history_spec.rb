require 'spec_helper'

describe 'when creating a product history' do
  before(:each) do
    product = FactoryGirl.create(:product)
    visit new_product_history_path(product)
    fill_in 'product_history_date',   with: date
    fill_in 'product_history_price',  with: price
    fill_in 'product_history_count',  with: count
  end

  let(:date) { Date.today.to_s }
  let(:price) { Faker::Number.number(5) }
  let(:count) { Faker::Number.number(5) }
  let(:submit) { 'Save' }

  describe 'with valid information' do
    it 'should redirects to manufacturer#show page' do
      expect { click_button submit }.to change(ProductHistory, :count)
      expect(page).to have_content count
    end
  end

  describe 'with invalid information' do
    describe 'when date is blank' do
      let(:date) { '' }

      it 'should return error message' do
        expect { click_button submit }.not_to change(ProductHistory, :count)
        error = page.has_selector?(:xpath,
                                   "//input[@id='product_history_date']/../span[text()=\"can't be blank\"]")
        expect(error).to be_true
      end
    end

    describe 'when count is blank' do
      let(:count) { '' }

      it 'should return error message' do
        expect { click_button submit }.not_to change(ProductHistory, :count)
        error = page.has_selector?(:xpath,
                                   "//input[@id='product_history_count']/../span[contains(.,\"can't be blank\")]")
        expect(error).to be_true
      end
    end

    describe 'when count is negative' do
      let(:count) { -1 }

      it 'should return error message' do
        expect { click_button submit }.not_to change(ProductHistory, :count)
        error = page.has_selector?(:xpath,
                                   "//input[@id='product_history_count']/../span[text()='must be greater than or equal to 0']")
        expect(error).to be_true
      end
    end

    describe 'when price is blank' do
      let(:price) { '' }

      it 'should return error message' do
        expect { click_button submit }.not_to change(ProductHistory, :count)
        error = page.has_selector?(:xpath,
                                   "//input[@id='product_history_price']/../span[contains(.,\"can't be blank\")]")
        expect(error).to be_true
      end
    end

    describe 'when price is negative' do
      let(:price) { -1 }

      it 'should return error message' do
        expect { click_button submit }.not_to change(ProductHistory, :count)
        error = page.has_selector?(:xpath,
                                   "//input[@id='product_history_price']/../span[text()='must be greater than or equal to 0']")
        expect(error).to be_true
      end
    end
  end
end

describe 'pagination' do
  before(:each) { FactoryGirl.create_list(:product_history, 30, product: product) }

  let(:product) { FactoryGirl.create(:product) }
  let(:wait) { Selenium::WebDriver::Wait.new(:timeout => 10) }

  context 'on first page' do
    before(:each) { visit product_path(product) }

    it 'previous button is disabled' do
      page.has_selector?(:xpath, "//ul[contains(@class,'pager')]//li[@class='previous disabled']") == true
    end

    it 'clicking next should go back next page', js: true do
      html = page.html
      click_link 'Next'
      wait.until { page.has_css?("li[class='previous']") }
      page.html.should_not == html
    end
  end

  context 'on last page' do
    before(:each) { visit "#{product_path(product)}?page=3" }

    it 'next button is disabled' do
      page.has_selector?(:xpath, "//ul[contains(@class,'pager')]//li[@class='next disabled']") == true
    end

    it 'clicking back should go back on previous page', js: true do
      html = page.html
      click_link 'Previous'
      wait.until { page.has_css?("li[class='next']") }
      page.html.should_not == html
    end
  end
end