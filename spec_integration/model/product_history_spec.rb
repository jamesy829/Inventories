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
                                   "//input[@id='product_history_count']/../span[text()=\"can't be blank\"]")
        expect(error).to be_true
      end
    end

    describe 'when price is blank' do
      let(:price) { '' }

      it 'should return error message' do
        expect { click_button submit }.not_to change(ProductHistory, :count)
        error = page.has_selector?(:xpath,
                                   "//input[@id='product_history_price']/../span[text()=\"can't be blank\"]")
        expect(error).to be_true
      end
    end
  end
end