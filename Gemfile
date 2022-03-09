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
gem "rails", "= 6.1.4"

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
gem "puma", "4.3.7"

# cron manager
gem "whenever"

gem "ancestry"

# fontawesome icons
gem "font-awesome-sass", "~> 5.15"

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
gem "aws-sdk-ec2"
gem "aws-sdk-lightsail"
gem "aws-sdk-sns"
gem "aws-sdk-rails" # TODO: remove this and install only ses


# Rubyzip to compress files
gem "rubyzip", "~> 2.3.0"
gem "zip-zip" #backward compatibility

# Generate pdf
gem "prawn"
gem "prawn-table"
gem "combine_pdf"

# Adding docx var support
gem "docx_replace"
gem "doc_ripper" # text extractor

# Convert files to pdf
gem "libreconv"

gem "jwt"

# Excel file generator gems
gem "caxlsx"

gem "caxlsx_rails"

gem "rack-cors"

gem "sprockets", "< 4"

# debugging tools
gem "honeybadger", "~> 4.0"

gem "ruby_cowsay"

# faster json parser library
gem "fast_jsonparser"

gem "active_record_union"

gem "webpush", "= 1.1.0"

# Social Login
gem "omniauth"
gem 'omniauth-google-oauth2', '= 1.0'
gem 'omniauth-facebook', '= 9.0'
gem 'google-api-client', require: 'google/apis/calendar_v3'


# cross-platform interface for filesystem information
gem 'sys-filesystem', '~> 1.4'

gem "sentry-ruby"
gem "sentry-rails"

group :development, :test do

    # Fake data generator
    # https://github.com/faker-ruby/faker
    gem "faker"

    # Preview email in the default browser instead of sending it
    # https://github.com/ryanb/letter_opener
    gem "letter_opener"

    # Documentation generation tool for the Ruby programming language
    # https://github.com/lsegal/yard
    gem "yard"

    # RSpec for testing
    # https://github.com/rspec/rspec-rails
    # Using beta version of rspect-rails due: https://github.com/rails/rails/issues/35417
    gem "rspec-rails", "~> 4.0.0.beta2"

    # https://github.com/rspec/rspec-mocks
    gem "rspec-mocks", "~> 3.10"

    # Code coverage
    # https://github.com/simplecov-ruby/simplecov
    gem "simplecov", require: false

    # Code coverage stats in the console
    # https://github.com/chetan/simplecov-console
    gem "simplecov-console", require: false

    # Call "byebug" anywhere in the code to stop execution and get a debugger console
    gem "byebug", platforms: [:mri, :mingw, :x64_mingw]

    # Avoiding polling in widows
    gem "wdm", ">= 0.1.0" if Gem.win_platform?

    # Workaround for nokogiri when using ruby 2.7.0
    gem "nokogiri", "~> 1.11.0.rc1" if Gem.win_platform?

    # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
    gem "tzinfo-data" if Gem.win_platform?

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
    gem "capybara", ">= 2.15"

    #gem "selenium-webdriver"

    # Easy installation and use of chromedriver to run system tests with Chrome
    #gem "chromedriver-helper"

    gem "rails-controller-testing"
    gem "rails-ujs"

    # Sprockets needs jquery to render views on test environment
    gem "jquery-rails"

    # FactoryBot
    # https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#configure-your-test-suite
    gem "factory_bot_rails"
end

Lesli::engines.each do |engine|

    next if engine[:name] == "Lesli"

    if engine[:type] == "builder" || engine[:type] == "engine"
        engine_installation_path = File.expand_path("../engines/#{ engine[:code] }", __FILE__)
        gem engine[:code], path: engine_installation_path if File.exists?(engine_installation_path)
        next
    end

    if engine[:type] == "gem"
        source "https://rubygems.pkg.github.com/leitfaden" do
            gem engine[:code], engine[:version]
        end
    end
end
