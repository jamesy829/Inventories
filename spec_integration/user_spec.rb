require 'spec_helper'

describe 'User', js: true do
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    visit new_user_session_path
    Page::User::SignIn.login_with(user.email, user.password)
  end

  subject { page }

  it { should have_content 'Signed in successfully.' }
end