require 'spec_helper'
require "#{Rails.root}/lib/bootstrap_form/form_builder.rb"

include ActionView::Helpers
include ActionView::Context

class DummyClass < ActiveRecord::Base
  def self.columns() @columns ||= []; end
 
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end
  
  column :email, :string
  column :password, :string
  column :comments, :text
  column :status, :string
  column :misc, :string
  column :created_at, :datetime
  column :updated_at, :datetime

  validates :email, presence: true
end

describe BootstrapForm::FormBuilder do

  let(:dummy)   { stub_model(DummyClass, email: 'test@test.com', password: 'secret', comments: 'comments') }
  let(:builder) { described_class.new(:dummy, dummy, self, {}, nil) }

  describe '#alert_message' do
    before(:each) do
      dummy.email= nil
      dummy.valid?
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
    before { dummy.valid? }

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
      subject { builder.text_field :email}

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_email">Email</label><div class="col-sm-11"><input class="form-control" id="dummy_email" name="dummy[email]" type="text" value="test@test.com" /></div></div>} }
    end

    context 'password field is wrapped correctly' do
      subject { builder.password_field :password}

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_password">Password</label><div class="col-sm-11"><input class="form-control" id="dummy_password" name="dummy[password]" type="password" /></div></div>} }
    end

    context 'hidden field is wrapped correctly' do
      subject { builder.hidden_field :misc }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_misc">Misc</label><div class="col-sm-11"><input class="form-control" id="dummy_misc" name="dummy[misc]" type="hidden" /></div></div>} }
    end

    context 'file field is wrapped correctly' do
      subject { builder.file_field :misc }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_misc">Misc</label><div class="col-sm-11"><input class="form-control" id="dummy_misc" name="dummy[misc]" type="file" /></div></div>} }
    end

    context 'text area is wrapped correctly' do
      subject { builder.text_area :comments }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_comments">Comments</label><div class="col-sm-11"><textarea class="form-control" id="dummy_comments" name="dummy[comments]">\ncomments</textarea></div></div>} }
    end

    context 'color field is wrapped correctly' do
      subject { builder.color_field :misc }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_misc">Misc</label><div class="col-sm-11"><input class="form-control" id="dummy_misc" name="dummy[misc]" type="color" value="#000000" /></div></div>} }
    end

    context 'search field is wrapped correctly' do
      subject { builder.search_field :misc }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_misc">Misc</label><div class="col-sm-11"><input class="form-control" id="dummy_misc" name="dummy[misc]" type="search" /></div></div>} }
    end

    context 'telephone field is wrapped correctly' do
      subject { builder.telephone_field :misc }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_misc">Misc</label><div class="col-sm-11"><input class="form-control" id="dummy_misc" name="dummy[misc]" type="tel" /></div></div>} }
    end

    context 'phone field is wrapped correctly' do
      subject { builder.phone_field :misc }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_misc">Misc</label><div class="col-sm-11"><input class="form-control" id="dummy_misc" name="dummy[misc]" type="tel" /></div></div>} }
    end

    context 'phone field is wrapped correctly' do
      subject { builder.phone_field :misc }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_misc">Misc</label><div class="col-sm-11"><input class="form-control" id="dummy_misc" name="dummy[misc]" type="tel" /></div></div>} }
    end

    context 'date field is wrapped correctly' do
      subject { builder.date_field :created_at }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_created_at">Created at</label><div class="col-sm-11"><input class="form-control" id="dummy_created_at" name="dummy[created_at]" type="date" /></div></div>} }
    end

    context 'time field is wrapped correctly' do
      subject { builder.time_field :created_at }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_created_at">Created at</label><div class="col-sm-11"><input class="form-control" id="dummy_created_at" name="dummy[created_at]" type="time" /></div></div>} }
    end

    context 'datetime field is wrapped correctly' do
      subject { builder.datetime_field :created_at }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_created_at">Created at</label><div class="col-sm-11"><input class="form-control" id="dummy_created_at" name="dummy[created_at]" type="datetime" /></div></div>} }
    end

    context 'datetime local field is wrapped correctly' do
      subject { builder.datetime_local_field :created_at }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_created_at">Created at</label><div class="col-sm-11"><input class="form-control" id="dummy_created_at" name="dummy[created_at]" type="datetime-local" /></div></div>} }
    end

    context 'month field is wrapped correctly' do
      subject { builder.month_field :created_at }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_created_at">Created at</label><div class="col-sm-11"><input class="form-control" id="dummy_created_at" name="dummy[created_at]" type="month" /></div></div>} }
    end

    context 'week field is wrapped correctly' do
      subject { builder.week_field :created_at }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_created_at">Created at</label><div class="col-sm-11"><input class="form-control" id="dummy_created_at" name="dummy[created_at]" type="week" /></div></div>} }
    end

    context 'url field is wrapped correctly' do
      subject { builder.url_field :misc }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_misc">Misc</label><div class="col-sm-11"><input class="form-control" id="dummy_misc" name="dummy[misc]" type="url" /></div></div>} }
    end

    context 'email field is wrapped correctly' do
      subject { builder.email_field :email }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_email">Email</label><div class="col-sm-11"><input class="form-control" id="dummy_email" name="dummy[email]" type="email" value="test@test.com" /></div></div>} }
    end

    context 'number field is wrapped correctly' do
      subject { builder.number_field :misc }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_misc">Misc</label><div class="col-sm-11"><input class="form-control" id="dummy_misc" name="dummy[misc]" type="number" /></div></div>} }
    end

    context 'range field is wrapped correctly' do
      subject { builder.range_field :misc }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_misc">Misc</label><div class="col-sm-11"><input class="form-control" id="dummy_misc" name="dummy[misc]" type="range" /></div></div>} }
    end

    pending 'select field'
    pending 'collection_select'
    pending 'date_select'
    pending 'time_select'
    pending 'datetime_select'
  end

  describe '#generate_label' do
    context 'change label text' do
      subject { builder.text_field :email, label: 'Test Label' }

      it { should == %{<div class="form-group"><label class="col-sm-1 control-label" for="dummy_email">Test Label</label><div class="col-sm-11"><input class="form-control" id="dummy_email" name="dummy[email]" type="text" value="test@test.com" /></div></div>} }
    end
  end

  describe '#generate_field' do

  end
end
