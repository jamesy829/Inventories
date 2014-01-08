require 'spec_helper'

describe Product do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should ensure_length_of(:name).is_at_most(256) } 
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:sku_id) }
    it { should validate_uniqueness_of(:sku_id) }
    it { should validate_presence_of(:manufacturer) }
  end

  describe 'associations' do
    it { should belong_to(:manufacturer) }
    it { should have_many(:product_history) }
  end

end
