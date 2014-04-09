module Page
  module User
    module SignIn
      class << self
        include Capybara::DSL

        def login_with(username, password)
          fill_in 'Email', with: username
          fill_in 'Password', with: password
          click_button 'Sign in'
        end
      end
    end
  end
end