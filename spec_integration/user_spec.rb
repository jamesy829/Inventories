require 'spec_helper'

describe 'User', js: true do

  describe 'when signing in' do
    let(:user) { FactoryGirl.create(:user) }

    before(:each) { visit new_user_session_path }

    describe 'with valid information' do
      before { Page::User::SignIn.login_with(user.email, user.password) }

      it 'should redirects to manufacturer#index page' do
        expect(page).to have_content 'Signed in successfully.'
      end
    end

    describe 'with invalid information' do
      describe 'when email is blank' do
        before { Page::User::SignIn.login_with(email, user.password) }

        let(:email) { '' }

        it 'should have alert' do
          error = page.has_selector?(:xpath,
                                    "//div[@id='flash_alert'][text()=\"Invalid email or password.\"]")
          expect(error).to be_true
        end
      end

      describe 'when password is blank' do
        before { Page::User::SignIn.login_with(user.email, password) }

        let(:password) { '' }

        it 'should have alert' do
          error = page.has_selector?(:xpath,
                                    "//div[@id='flash_alert'][text()=\"Invalid email or password.\"]")
          expect(error).to be_true
        end
      end
    end
  end

  describe 'when signing up' do
    before(:each) do
      visit new_user_registration_path
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', with: password
    end

    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Number.number(8) }
    let(:submit) { 'Sign up' }

    describe 'with valid information' do
      it 'should redirects to manufacturer#index page' do
        expect { click_button submit }.to change(User, :count)
        expect(page).to have_content 'Manufacturers'
      end
    end

    describe 'with invalid information' do
      describe 'when email is blank' do
        let(:email) { '' }

        it 'should return error message' do
          expect { click_button submit }.not_to change(User, :count)
          error = page.has_selector?(:xpath,
                                    "//input[@id='user_email']/../span[text()=\"can't be blank\"]")
          expect(error).to be_true
        end
      end

      describe 'when password is blank' do
        let(:password) { '' }

        it 'should return error message' do
          expect { click_button submit }.not_to change(User, :count)
          error = page.has_selector?(:xpath,
                                    "//input[@id='user_password']/../span[text()=\"can't be blank\"]")
          expect(error).to be_true
        end
      end

      context 'uniqueness' do
        let(:user) { FactoryGirl.create(:user) }

        describe 'when email is taken' do
          let(:email) { user.email }

          it 'should return error message' do
            expect { click_button submit }.not_to change(User, :count)
            error = page.has_selector?(:xpath,
                                    "//input[@id='user_email']/../span[text()='has already been taken']")
            expect(error).to be_true
          end
        end
      end
    end
  end
end
