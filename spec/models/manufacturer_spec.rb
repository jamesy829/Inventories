require 'spec_helper'

describe Manufacturer do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should ensure_length_of(:name).is_at_most(256) } 
  end
end
