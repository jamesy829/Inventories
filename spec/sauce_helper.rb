# You should edit this file with the browsers you wish to use
# For options, check out http://saucelabs.com/docs/platforms
require "sauce"
require "sauce/capybara"

Sauce.config do |config|
  config[:browsers] = [
    ["Windows 7", "Firefox", "20"],
    ["Linux", "Chrome", "32"]
  ]
end
