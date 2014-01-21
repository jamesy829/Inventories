include Rails.application.routes.url_helpers

shared_examples_for 'pager' do |hash|
  before(:each) { FactoryGirl.create_list(hash[:factory_girl], 11) }

  context 'on first page', js: true do
    before(:each) { visit hash[:route].call;binding.pry }

    it 'previous button is disabled' do
      page.has_selector?(:xpath, "//ul[contains(@class,'pager')]//li[@class='previous disabled']").should == true
    end

    it 'clicking next should go back next page'
  end

  context 'on last page' do
    it 'next button is disabled'
    it 'clicking back should go back on previous page'
  end
end