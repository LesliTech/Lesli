=begin

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

require "./lesli"

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"

# · Rails, gem, dependencies and tools

# Rails framework
gem "rails", "= 6.1.0"

# Rails translations
gem "rails-i18n", "= 6.0.0"

# Rails translations for JavaScript frontend
gem "i18n-js"

# SASS compiler for RoR
gem "sass-rails", "= 6"

# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"

# Authentication management for RoR
gem "devise"

# Soft-delete database records
gem "acts_as_paranoid"

# Development web server
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
gem "aws-sdk-sns"
gem "aws-sdk-rails"


# Rubyzip to compress files
gem "rubyzip", "~> 2.3.0"
gem 'zip-zip' #backward compatibility

# files reader
gem 'yomu'

# Generate pdf
gem "prawn"
gem 'prawn-table'
gem "combine_pdf"

# Adding docx var support
gem 'docx_replace'

# Convert files to pdf
gem "libreconv"

gem "jwt"

# Excel file generator gems
gem "axlsx"

gem "caxlsx_rails"

gem "rack-cors"

gem "sprockets", "< 4"

# debugging tools
gem "honeybadger", '~> 4.0'

gem "ruby_cowsay"

# faster json parser library
gem 'fast_jsonparser'

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

    Lesli::engines.each do |engine|
        engine_installation_path = File.expand_path("../engines/#{engine["code"]}", __FILE__)
        gem engine["code"], path: engine_installation_path if File.exists?(engine_installation_path)
    end
end

group :development do

    gem "web-console", ">= 3.3.0"

    gem "listen", "3.2.1"
    
    gem "spring"

    gem "spring-watcher-listen", "~> 2.0.0"

    gem "rack-mini-profiler"
    gem "memory_profiler"

end

group :test do

    # Adds support for Capybara system testing and selenium driver
    #gem "capybara", ">= 2.15"

    #gem "selenium-webdriver"
    
    # Easy installation and use of chromedriver to run system tests with Chrome
    #gem "chromedriver-helper"

    gem "rails-controller-testing"
    
end


if !Lesli::instance[:local_engines] && Lesli::instance[:name] != "Lesli"
    source "https://rubygems.pkg.github.com/leitfaden" do
        gem Lesli::instance[:code], Lesli::instance[:version]
    end
end
