require 'spec_helper'

describe ProductHistory do
  describe 'validations' do
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:count) }
    it { should validate_presence_of(:price) }
  end

  describe 'associations' do
    it { should belong_to(:product) }
  end
end
