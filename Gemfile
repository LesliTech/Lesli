=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end


# Lesli engines parser
require "./lesli"


source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }


# main ruby version
ruby "3.1.2"



# · RAILS: gem, dependencies and tools

# Rails framework
gem "rails", "7.0.4.3"

# A set of common locale data and translations to internationalize and/or localize your Rails applications.
gem "rails-i18n", "7.0.6"

# It's a small library to provide the Rails I18n translations on the Javascript.
# We must stick to the version 3 due version 4 changed completed the behavior of
# the locale files creation for the frontend
gem "i18n-js", "3.9.2" # "4.2.3"

# Integrate SassC-Ruby into Rails.
gem "sassc-rails", "2.1.2"

# Pg is the Ruby interface to the PostgreSQL RDBMS. It works with PostgreSQL 9.3 and later.
gem "pg", "1.5.2"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "1.16.0", require: false



# · Tools used to extend Rails functionality

# text search
#gem "pg_search"

# UNIONs in ActiveRecord! Adds proper union and union_all methods to ActiveRecord::Relation.
gem "active_record_union", "1.3.0"

# ActiveRecord plugin allowing you to hide and restore records without actually deleting them. 
gem "acts_as_paranoid", "0.8.1"

# faster json parser library
gem "fast_jsonparser", "0.6.0"

# Middleware that will make Rack-based apps CORS compatible. 
gem "rack-cors", "1.1.1"

# Upload files in your Ruby applications, map them to a range of ORMs, store them on different backends.
#gem "carrierwave", "2.2.2"

# Clean, powerful, agnostic, customizable and sophisticated paginator for Rails
gem "kaminari", "1.2.2"

# Clean ruby syntax for writing and deploying cron jobs.
gem "whenever", "1.0.0"

# A pure ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard
gem "jwt", "2.7.0"



# · Tools used to build the LESLI Platform

# Message utilities for the Ruby console.
gem "L2", "0.5.2"

# Flexible authentication solution for Rails with Warden
gem "devise", "4.9.2"

# A generalized Rack framework for multiple-provider authentication.
# gem "omniauth", "2.0.4"

# A Google OAuth2 strategy for OmniAuth 1.x. This allows you to login to Google with your ruby app.
# gem "omniauth-google-oauth2", "1.0.0"

# Facebook OAuth2 Strategy for OmniAuth
# gem "omniauth-facebook", "9.0.0"

# Client for accessing Google APIs
# gem "google-api-client", "0.53.0", require: 'google/apis/calendar_v3'

# Official AWS Ruby gem that provides rails utilities
# gem "aws-sdk-rails", "3.6.1"

# Official AWS Ruby gem for Amazon Simple Storage Service (Amazon S3). This gem is part of the AWS SDK for Ruby.
# gem "aws-sdk-s3", "1.113.0"

# Official AWS Ruby gem for Amazon Elastic Compute Cloud (Amazon EC2). This gem is part of the AWS SDK for Ruby.
# gem "aws-sdk-ec2", "1.300.0"

# Official AWS Ruby gem for Amazon Lightsail. This gem is part of the AWS SDK for Ruby.
# gem "aws-sdk-lightsail", "1.63.0"

# Official AWS Ruby gem for Amazon Simple Notification Service (Amazon SNS). 
# gem "aws-sdk-sns", "1.53.0"

# Official AWS Ruby gem for Amazon Simple Email Service (Amazon SES).
# gem "aws-sdk-ses", "1.47.0"

# Standalone provider to use the Amazon Web Services in applications
# gem "fog-aws", "3.13.0"

# HTML to PDF
gem "wicked_pdf", "~> 2.1.0"

# Provides binaries for WKHTMLTOPDF project in an easily accessible package.
gem "wkhtmltopdf-binary", "~> 0.12.6"

# Prawn is a fast, tiny, and nimble PDF generator for Ruby
#gem "prawn", "2.4.0"

# Prawn::Table provides tables for the Prawn PDF toolkit
#gem "prawn-table", "0.2.2"

# A nifty gem, in pure Ruby, to parse PDF files and combine (merge) them with other PDF files
#gem "combine_pdf"

# Convert office documents to PDF using LibreOffice.
#gem "libreconv", "0.9.5"

# Find and replace variables inside a Micorsoft Word (.docx) template
#gem "docx_replace", "1.0.0"

# Scrape text from common file formats (.pdf,.doc,.docx, .sketch, .txt) with a single convenient command.
#gem "doc_ripper", "0.0.9"

# xlsx spreadsheet generation with charts, images, automated column width, customizable styles and full schema validation.
# gem "caxlsx", "3.1.1"

# Caxlsx_Rails provides an Caxlsx renderer so you can move all your spreadsheet code from your controller into view files.
# gem "caxlsx_rails", "0.6.2"

# http/rest api client library
# gem "faraday" #Workaround to allow google-cloud-firestore work

# rubyzip is a ruby module for reading and writing zip files
# gem "rubyzip", "2.3.2"

# In Gem hell migrating to RubyZip v1.0.0? Include zip-zip in your Gemfile and everything's coming up roses!
# gem "zip-zip", "0.3"

# HTTP User Agent parser
gem "useragent", "0.16.10"

# The sys-filesystem library provides a cross-platform interface for gathering filesystem information.
gem "sys-filesystem", "1.4.3"

# collection of all country flags in SVG
gem "flag-icons-rails", "= 3.4.6.1"

# Make managing application errors a more pleasant experience.
gem "honeybadger", "5.2.1"




# · Gems for development & test environment
group :development, :test do

    # Puma is a simple, fast, threaded, and highly parallel HTTP 1.1 server for Ruby/Rack applications.
    gem "puma", "6.2.2"

    # Fake data generator
    # https://github.com/faker-ruby/faker
    gem "faker"

    # Preview email in the default browser instead of sending it
    # https://github.com/ryanb/letter_opener
    gem "letter_opener", "1.8.1"

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
    gem "simplecov", "0.22.0", require: false

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

    # sys-proctable for rails 7 compatibility in Windows platforms
    gem "sys-proctable" if Gem.win_platform?

end




# · Gems for development environment
group :development do

    # Go faster, off the Rails
    gem "derailed_benchmarks", "2.1.2"

    gem "sprockets", "4.0.3"

    # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
    # this gem is necessary to use the rails generator 
    gem "sprockets-rails", "3.4.2"

    # The Listen gem listens to file modifications and notifies you about the changes. Works everywhere!
    gem "listen", "3.8.0"

    gem "spring"

    gem "spring-watcher-listen", "~> 2.0.0"

    #gem "web-console", ">= 3.3.0"

    #gem "rack-mini-profiler"

    #gem "memory_profiler"

    # A fast, safe and extensible Markdown to (X)HTML parser
    gem "redcarpet", "3.6.0"

    # Automatically generate an SVG sprite from a folder of SVG icons.
    # Generate svg sprite for the lesli icons:
    # first clean the svg files with svgo nodejs module: https://github.com/svg/svgo
    # and then rename _application-svgs.svg to _application-svgs.html.erb
    # see the readme file in the icons folder for usage examples
    gem "svgeez", "4.1"

    # Rouge aims to a be a simple, easy-to-extend drop-in replacement for pygments.
    gem "rouge", "3.28.0"

    # Static code analyser to find security issues in Rails applications 
    gem "spektr", "0.3.4"

    # Brakeman detects security vulnerabilities in Ruby on Rails applications via static analysis.
    # brakeman -o brakeman.html --faster
    gem "brakeman", "5.4.1"

end




# · Gems for test environment
group :test do

    # Adds support for Capybara system testing and selenium driver
    gem "capybara", ">= 2.15"

    gem "rails-controller-testing"
    gem "rails-ujs"

    # Sprockets needs jquery to render views on test environment
    gem "jquery-rails"

    # FactoryBot
    # https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#configure-your-test-suite
    gem "factory_bot_rails"

end




# · Automatically load Lesli modules as gems
Lesli::engines.each do |engine|

    next if engine[:name] == "Lesli"

    if engine[:type] == "builder" || engine[:type] == "engine"
        engine_installation_path = File.expand_path("../engines/#{ engine[:code] }", __FILE__)
        gem engine[:code], path: engine_installation_path if File.exists?(engine_installation_path)
        next
    end

    if engine[:type] == "gem"
        source "https://rubygems.pkg.github.com/LesliTech" do
            gem engine[:code], engine[:version]
        end
    end

end



=begin

REFERENCES:

    https://github.com/Bearer/bearer
    Scan your source code against top security and privacy risks. 
    
=end
