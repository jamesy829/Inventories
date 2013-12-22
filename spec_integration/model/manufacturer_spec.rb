require 'spec_helper'

describe 'when creating a manufacturer' do
  before { visit new_manufacturer_path }
  let(:submit) { 'Create Manufacturer' }

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
        expect(page).to have_content "Name can't be blank"
      end
    end

    describe 'when name exceed 256 characters' do
      before { fill_in 'manufacturer_name', with: 'x' * 257 }

      it 'should return error message' do
        expect { click_button submit }.not_to change(Manufacturer, :count)
        expect(page).to have_content 'Name is too long (maximum is 256 characters)'
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
