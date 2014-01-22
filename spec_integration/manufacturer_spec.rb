require 'spec_helper'

describe 'when creating a manufacturer' do
  before { visit new_manufacturer_path }
  let(:submit) { 'Save' }

  describe 'with valid information' do
    before { fill_in 'manufacturer_name', with: 'Manufacturer Name' }

    it 'should redirects to manufacturer#show page' do
      expect { click_button submit }.to change(Manufacturer, :count)
      expect(page).to have_content 'Manufacturer Name'
    end
  end

  describe 'with invalid information' do
    describe 'when name is blank' do
      it 'should return error message' do
        expect { click_button submit }.not_to change(Manufacturer, :count)
        error = page.has_selector?(:xpath,
                                   "//input[@id='manufacturer_name']/../span[text()=\"can't be blank\"]")
        expect(error).to be_true
      end
    end

    describe 'when name exceed 256 characters' do
      before { fill_in 'manufacturer_name', with: 'x' * 257 }

      it 'should return error message' do
        expect { click_button submit }.not_to change(Manufacturer, :count)
        error = page.has_selector?(:xpath,
                                   "//input[@id='manufacturer_name']/../span[text()='is too long (maximum is 256 characters)']")
        expect(error).to be_true
      end
    end
  end 
end

describe 'when manufacturer is deleted', js: true do
  before do
    @manufacturer = FactoryGirl.create(:manufacturer)
    visit manufacturers_path
  end

  it 'should redirects to manufacturer#index and manufacturer is removed' do
    count = Manufacturer.count
    within(:xpath, "//tr[@id='#{@manufacturer.name}']") { click_link 'Delete' } 
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_no_content @manufacturer.name
    expect(Manufacturer.count).to be < count
  end
end

describe 'when manufacturer is viewed' do
  before do
    @manufacturer = FactoryGirl.create(:manufacturer)
    visit manufacturer_path(@manufacturer)
  end

  it 'should be able to see add product link' do
    expect(page.has_link? 'Add Product').to be_true
  end

  it 'should render add product form when add product link is clicked' do
    click_link 'Add Product'
    expect(page).to have_content 'New Product'
  end
end
