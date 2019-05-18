source 'https://rubygems.org'
git_source(:github) {|repo| "https://github.com/#{repo}.git"}

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'

# Use Puma as the app server
gem 'puma', '~> 3.11'

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use to compress and reduce javascript file sizes
gem 'uglifier'

# HAML template procesor
gem 'haml-rails'

# Devise gem use for authentication
gem 'devise'

# Add can can gem to authorization and roles permissions
gem "cancan"

# Add carrierwave to upload documents
gem 'carrierwave'

# Resolve issue with the bcrypt gem in windows
gem 'bcrypt', platform: :ruby

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'

  gem 'faker'

end

group :test do

  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'

  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
  
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
