require 'spec_helper'

describe 'Manufacturer Integration', sauce: true do
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

    context 'on overview' do
      subject { find('div#overview') }

      it { should have_content @manufacturer.name }
    end

    it 'should be able to see add product link' do
      expect(page.has_link? 'Add Product').to be_true
    end

    it 'should render add product form when add product link is clicked' do
      click_link 'Add Product'
      expect(page).to have_content 'New Product'
    end
  end

  describe 'pagination' do
    context '#index' do
      before(:each) { FactoryGirl.create_list(:manufacturer, 30) }

      context 'on first page' do
        before(:each) { visit manufacturers_path }

        it 'previous button is disabled' do
          page.has_selector?(:xpath, "//ul[contains(@class,'pager')]//li[@class='previous disabled']") == true
        end

        it 'clicking next should go back next page', js: true do
          html = page.html
          click_link 'Next'
          @wait.until { page.has_css?("li[class='previous']") }
          page.html.should_not == html
        end
      end

      context 'on last page' do
        before(:each) { visit "#{manufacturers_path}?page=3" }

        it 'next button is disabled' do
          page.has_selector?(:xpath, "//ul[contains(@class,'pager')]//li[@class='next disabled']") == true
        end

        it 'clicking back should go back on previous page', js: true do
          html = page.html
          click_link 'Previous'
          @wait.until { page.has_css?("li[class='next']") }
          page.html.should_not == html
        end
      end
    end

    context '#show' do
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
          @wait.until { page.has_css?("li[class='previous']") }
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
          @wait.until { page.has_css?("li[class='next']") }
          page.html.should_not == html
        end
      end
    end
  end
end
