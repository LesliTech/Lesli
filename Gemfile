=begin

Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

require "./lesli_info"

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'

gem 'rails-i18n', '~> 6.0.0'

gem 'i18n-js'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5'

# HAML template procesor
gem 'haml-rails'

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'

# Add can can can gem to authorization and roles permissions
gem "cancancan"

# ActsAsParanoid
gem 'acts_as_paranoid'

# Use Puma as the app server
gem 'puma', '~> 3.11'

#gem 'devise'
gem 'devise' #, git: 'https://github.com/plataformatec/devise.git'

# cron manager
gem 'whenever'

gem 'ancestry'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do

    gem 'faker'

    # Call 'byebug' anywhere in the code to stop execution and get a debugger console
    gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

    # Using beta version of rspect-rails due: https://github.com/rails/rails/issues/35417
    gem 'rspec-rails', '~> 4.0.0.beta2'

    # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
    gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

    gem 'yard'

    # Avoiding polling for changes
    #gem 'wdm', '>= 0.1.0' if Gem.win_platform?

end

group :development do

    gem 'web-console', '>= 3.3.0'

    gem 'listen', '>= 3.0.5', '< 3.2'
    
    gem 'spring'

    gem 'spring-watcher-listen', '~> 2.0.0'

end

group :test do

    # Adds support for Capybara system testing and selenium driver
    #gem 'capybara', '>= 2.15'

    #gem 'selenium-webdriver'
    
    # Easy installation and use of chromedriver to run system tests with Chrome
    #gem 'chromedriver-helper'

    gem 'rails-controller-testing'
    
end

group :production do
    # S3 SDK for active storage support
    gem "aws-sdk-s3"
end

# Loading installed engines
LesliInfo::engines.each do |engine|
    engine_installation_path = File.expand_path("../engines/#{engine[:name]}", __FILE__)
    gem engine[:code], path: engine_installation_path if File.exists?(engine_installation_path)
end
