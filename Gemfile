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

# · RAILS: gem, dependencies and tools

# Rails framework
gem "rails", "7.0.2.2"

# A set of common locale data and translations to internationalize and/or localize your Rails applications.
gem "rails-i18n", "7.0.2"

# It's a small library to provide the Rails I18n translations on the Javascript.
gem "i18n-js", "3.9.1"

# Integrate SassC-Ruby into Rails.
gem "sassc-rails", "2.1.2"

# Pg is the Ruby interface to the PostgreSQL RDBMS. It works with PostgreSQL 9.3 and later.
gem "pg", "1.3.3"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "1.10.3", require: false



# · Tools used to extend Rails functionality

# UNIONs in ActiveRecord! Adds proper union and union_all methods to ActiveRecord::Relation.
gem "active_record_union", "1.3.0"

# ActiveRecord plugin allowing you to hide and restore records without actually deleting them. 
gem "acts_as_paranoid", "0.8.0"

# faster json parser library
gem "fast_jsonparser", "0.5.0"

# Middleware that will make Rack-based apps CORS compatible. 
gem "rack-cors", "1.1.1"

# Upload files in your Ruby applications, map them to a range of ORMs, store them on different backends.
gem "carrierwave", "2.2.2"

# Clean, powerful, agnostic, customizable and sophisticated paginator for Rails
gem "kaminari", "1.2.2"

# Clean ruby syntax for writing and deploying cron jobs.
gem "whenever", "1.0.0"

# A pure ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard
gem "jwt", "2.3.0"

# Font-Awesome SASS gem for use in Ruby projects
gem "font-awesome-sass", "~> 5.15.1"



# · Tools used to build the LESLI Platform

# Message utilities for the Ruby console
gem "LRM", "0.1.0"

# Flexible authentication solution for Rails with Warden
gem "devise", "4.8.1"

# A generalized Rack framework for multiple-provider authentication.
gem "omniauth", "2.0.4"

# A Google OAuth2 strategy for OmniAuth 1.x. This allows you to login to Google with your ruby app.
gem "omniauth-google-oauth2", "1.0.0"

# Facebook OAuth2 Strategy for OmniAuth
gem "omniauth-facebook", "9.0.0"

# Client for accessing Google APIs
gem "google-api-client", "0.53.0", require: 'google/apis/calendar_v3'

# Official AWS Ruby gem that provides rails utilities
gem "aws-sdk-rails", "3.6.1"

# Official AWS Ruby gem for Amazon Simple Storage Service (Amazon S3). This gem is part of the AWS SDK for Ruby.
gem "aws-sdk-s3", "1.113.0"

# Official AWS Ruby gem for Amazon Elastic Compute Cloud (Amazon EC2). This gem is part of the AWS SDK for Ruby.
gem "aws-sdk-ec2", "1.300.0"

# Official AWS Ruby gem for Amazon Lightsail. This gem is part of the AWS SDK for Ruby.
gem "aws-sdk-lightsail", "1.63.0"

# Official AWS Ruby gem for Amazon Simple Notification Service (Amazon SNS). 
gem "aws-sdk-sns", "1.53.0"

# Official AWS Ruby gem for Amazon Simple Email Service (Amazon SES).
gem "aws-sdk-ses", "1.47.0"

# Standalone provider to use the Amazon Web Services in applications
gem "fog-aws", "3.13.0"

# Prawn is a fast, tiny, and nimble PDF generator for Ruby
gem "prawn", "2.4.0"

# Prawn::Table provides tables for the Prawn PDF toolkit
gem "prawn-table", "0.2.2"

# A nifty gem, in pure Ruby, to parse PDF files and combine (merge) them with other PDF files
gem "combine_pdf"

# Convert office documents to PDF using LibreOffice.
gem "libreconv", "0.9.5"

# Find and replace variables inside a Micorsoft Word (.docx) template
gem "docx_replace", "1.0.0"

# Scrape text from common file formats (.pdf,.doc,.docx, .sketch, .txt) with a single convenient command.
gem "doc_ripper", "0.0.9"

# xlsx spreadsheet generation with charts, images, automated column width, customizable styles and full schema validation.
gem "caxlsx", "3.1.1"

# Caxlsx_Rails provides an Caxlsx renderer so you can move all your spreadsheet code from your controller into view files.
gem "caxlsx_rails", "0.6.2"

# A fast, safe and extensible Markdown to (X)HTML parser
gem "redcarpet", "3.5.1"

# HTTP/REST API client library.
# gem "faraday", "2.2.0"
gem "faraday" #Workaround to allow google-cloud-firestore work

# rubyzip is a ruby module for reading and writing zip files
gem "rubyzip", "2.3.2"

# In Gem hell migrating to RubyZip v1.0.0? Include zip-zip in your Gemfile and everything's coming up roses!
gem "zip-zip", "0.3"

# HTTP User Agent parser
gem "useragent", "0.16.10"

# The sys-filesystem library provides a cross-platform interface for gathering filesystem information.
gem "sys-filesystem", "1.4.3"

# collection of all country flags in SVG
gem "flag-icons-rails", "= 3.4.6.1"

# Make managing application errors a more pleasant experience.
gem "honeybadger", "4.11.0"

# Cowsay, written in ruby, as a gem.
gem "ruby_cowsay", "0.1.3"

group :development, :test do

    # Puma is a simple, fast, threaded, and highly parallel HTTP 1.1 server for Ruby/Rack applications.
    gem "puma", "5.6.2"

    # Fake data generator
    # https://github.com/faker-ruby/faker
    gem "faker"

    # Preview email in the default browser instead of sending it
    # https://github.com/ryanb/letter_opener
    gem "letter_opener"

    # Documentation generation tool for the Ruby programming language
    # https://github.com/lsegal/yard
    gem "yard"

    # rspec-rails is a testing framework for Rails 5+.
    # https://github.com/rspec/rspec-rails
    # Using beta version of rspect-rails due: https://github.com/rails/rails/issues/35417
    gem "rspec-rails", "= 5.1.0"

    # https://github.com/rspec/rspec-mocks
    gem "rspec-mocks", "~> 3.10"

    # Code coverage
    # https://github.com/simplecov-ruby/simplecov
    gem "simplecov", "0.21.2", require: false

    # Code coverage stats in the console
    # https://github.com/chetan/simplecov-console
    gem "simplecov-console", "0.9.1", require: false

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

    # Go faster, off the Rails
    gem "derailed_benchmarks", "2.1.1"

    gem "sprockets", "4.0.3"

    # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
    # this gem is necessary to use the rails generator 
    gem "sprockets-rails", "3.4.2"

    # The Listen gem listens to file modifications and notifies you about the changes. Works everywhere!
    gem "listen", "3.7.1"

    gem "spring"

    gem "spring-watcher-listen", "~> 2.0.0"

    gem "web-console", ">= 3.3.0"

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
