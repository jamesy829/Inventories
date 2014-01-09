require 'spec_helper'

describe ProductHistory do
  describe 'scope' do
    let(:product)   { FactoryGirl.create(:product) }
    let!(:history1) { FactoryGirl.create(:product_history, product_id: product.id, date: 1.day.ago) }
    let!(:history2) { FactoryGirl.create(:product_history, product_id: product.id, date: 5.hours.ago) }
    let!(:history3) { FactoryGirl.create(:product_history, product_id: product.id, date: 1.hour.ago) }

    context 'order_by_date' do
      subject { product.product_histories.order_by_date }

      it { subject.first.should == history3 }
      it { subject.second.should == history2 }
      it { subject.last.should == history1 }
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:count) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:product) }
  end

  describe 'associations' do
    it { should belong_to(:product) }
  end
end
