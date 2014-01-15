require 'spec_helper'

require "#{Rails.root}/lib/bootstrap_form/form_builder.rb"

describe BootstrapForm::FormBuilder do
  include ActionView::Helpers
  include ActionView::Context

  let(:product)   { FactoryGirl.build_stubbed(:product, name: 'Product') }
  let(:builder)   { described_class.new(:product, product, self, {}, nil) }

  describe '#alert_message' do
    before(:each) do
      product.name = nil
      product.valid?
    end

    context 'is wrapped correctly' do
      subject { builder.alert_message }

      it { should == %{<div class="alert alert-danger" id="errorExplanation">The form contains 1 errors</div>} }
    end

    context 'can have custom message' do
      subject { builder.alert_message 'Please fix the following error' }

      it { should == %{<div class="alert alert-danger" id="errorExplanation">Please fix the following error</div>} }
    end

    context 'can change class name' do
      subject { builder.alert_message nil, class: 'test_class' }

      it { should == %{<div class="test_class" id="errorExplanation">The form contains 1 errors</div>} }
    end
  end

  describe '#submit' do
    before { product.valid? }

    context 'is wrapped correctly' do
      subject { builder.submit }

      it { should == %{<div class="form-group"><div class="col-sm-offset-1 col-sm-11"><input class="primary" name="commit" type="submit" value="Save" /></div></div>} }
    end

    context 'can have custom label' do
      subject { builder.submit button: 'test_label' }

      it { should == %{<div class="form-group"><div class="col-sm-offset-1 col-sm-11"><input class="primary" name="commit" type="submit" value="test_label" /></div></div>} }
    end

    context 'can have custom class' do
      subject { builder.submit class: 'test_class' }

      it { should == %{<div class="form-group"><div class="col-sm-offset-1 col-sm-11"><input class="test_class" name="commit" type="submit" value="Save" /></div></div>} }
    end

    context 'back link is specified' do
      subject { builder.submit back_link: 'test_link'}

      it { should == %{<div class="form-group"><div class="col-sm-offset-1 col-sm-11"><input class="primary" name="commit" type="submit" value="Save" /><a class="default" href="test_link">Back</a></div></div>} }
    end
  end

  describe '#create_tagged_field' do
    context 'text field is wrapped correctly' do
      subject { builder.text_field :name }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="product_name">Name</label><div class="col-sm-11"><input class="form-control" id="product_name" name="product[name]" type="text" value="Product" /></div></div>} }
    end

  end
end
