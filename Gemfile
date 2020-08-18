=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

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

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

require "./lesli"

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.0"

# · Rails, gem, dependencies and tools

# Rails framework
gem "rails", "= 6.0.3"

# Rails translations
gem "rails-i18n", "= 6.0.0"

gem "i18n-js"

# Use SCSS for stylesheets
gem "sass-rails", "= 6"

# HAML template procesor
gem "haml-rails"

# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"

#gem "devise"
gem "devise"

# Add can can can gem to authorization and roles permissions
gem "cancancan"

# ActsAsParanoid
gem "acts_as_paranoid"

# Use Puma as the app server
gem "puma", "4.3.3"

# cron manager
gem "whenever"

gem "ancestry"

# fontawesome icons
gem "font-awesome-sass", "~> 5.12.0"

# Collection of all country flags in SVG
gem "flag-icons-rails"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

gem "kaminari"

# HTTP client
gem "faraday"

gem "useragent"

# files upload management
gem "carrierwave", "~> 2.0"

# s3 client for carrierwave
gem "fog-aws", "= 3.6.4"
gem "aws-sdk-s3"

# Rubyzip to compress files
gem "rubyzip", "~> 2.3.0"

gem "jwt"

# Excel file generator gems
gem "axlsx"

gem "caxlsx_rails"

gem "rack-cors"

gem "sprockets", "< 4"

# debugging tools
gem 'honeybadger', '~> 4.0'

gem 'appsignal'

group :development, :test do

    gem "faker"

    # Call "byebug" anywhere in the code to stop execution and get a debugger console
    gem "byebug", platforms: [:mri, :mingw, :x64_mingw]

    # Using beta version of rspect-rails due: https://github.com/rails/rails/issues/35417
    gem "rspec-rails", "~> 4.0.0.beta2"

    # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
    gem "tzinfo-data" if Gem.win_platform?

    gem "yard"

    # Avoiding polling in widows
    gem "wdm", ">= 0.1.0" if Gem.win_platform?

    # Workaround for nokogiri when using ruby 2.7.0
    gem "nokogiri", "~> 1.11.0.rc1" if Gem.win_platform?

    # Preview emails in browser
    gem "letter_opener"

end

group :development do

    gem "web-console", ">= 3.3.0"

    gem "listen", "3.2.1"
    
    gem "spring"

    gem "spring-watcher-listen", "~> 2.0.0"

    gem "guard-livereload", "~> 2.5", require: false

    gem "capistrano",         require: false
    gem "capistrano-rvm",     require: false
    gem "capistrano-rails",   require: false
    gem "capistrano-bundler", require: false
    gem "capistrano3-puma",   require: false

end

group :test do

    # Adds support for Capybara system testing and selenium driver
    #gem "capybara", ">= 2.15"

    #gem "selenium-webdriver"
    
    # Easy installation and use of chromedriver to run system tests with Chrome
    #gem "chromedriver-helper"

    gem "rails-controller-testing"
    
end

# Loading installed engines
Lesli::engines.each do |engine|
    engine_installation_path = File.expand_path("../engines/#{engine["name"]}", __FILE__)
    gem engine["code"], path: engine_installation_path if File.exists?(engine_installation_path)
end
