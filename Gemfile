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

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails", "3.4.2"

# A set of common locale data and translations to internationalize and/or localize your Rails applications.
gem "rails-i18n", "7.0.6"

# It's a small library to provide the Rails I18n translations on the Javascript.
# We must stick to the version 3 due version 4 changed completed the behavior of
# the locale files creation for the frontend
gem "i18n-js", "3.9.2" # "4.2.3"

# Pg is the Ruby interface to the PostgreSQL RDBMS. It works with PostgreSQL 9.3 and later.
gem "pg", "1.5.3"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "1.16.0", require: false



# · Tools used to extend Rails functionality

# text search
gem "pg_search"

# UNIONs in ActiveRecord! Adds proper union and union_all methods to ActiveRecord::Relation.
gem "active_record_union", "1.3.0"

# ActiveRecord plugin allowing you to hide and restore records without actually deleting them. 
gem "acts_as_paranoid", "0.8.1"

# faster json parser library
gem "fast_jsonparser", "0.6.0"

# Middleware that will make Rack-based apps CORS compatible. 
gem "rack-cors", "1.1.1"

# Clean, powerful, agnostic, customizable and sophisticated paginator for Rails
gem "kaminari", "1.2.2"

# Clean ruby syntax for writing and deploying cron jobs.
gem "whenever", "1.0.0"

# A pure ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard
gem "jwt", "2.7.0"



# · Tools used to build the LESLI Platformx

# Message utilities for the Ruby console.
gem "L2", "0.5.2"

# Flexible authentication solution for Rails with Warden
gem "devise", "4.9.2"

# HTML to PDF
gem "wicked_pdf", "~> 2.1.0"

# Provides binaries for WKHTMLTOPDF project in an easily accessible package.
gem "wkhtmltopdf-binary", "~> 0.12.6"

# HTTP User Agent parser
gem "useragent", "0.16.10"

# The sys-filesystem library provides a cross-platform interface for gathering filesystem information.
gem "sys-filesystem", "1.4.3"

# Make managing application errors a more pleasant experience.
gem "honeybadger", "5.2.1"


# · Gems for development environment
group :development do

    # · Tools to build Lesli assets

    # collection of all country flags in SVG
    gem "flag-icons-rails", "3.4.6.1"

    # Integrate SassC-Ruby into Rails.
    gem "sassc-rails", "2.1.2"

    # Automatically generate an SVG sprite from a folder of SVG icons.
    # Generate svg sprite for the lesli icons:
    # first clean the svg files with svgo nodejs module: https://github.com/svg/svgo
    # and then rename _application-svgs.svg to _application-svgs.html.erb
    # see the readme file in the icons folder for usage examples
    gem "svgeez", "4.1"


    # · Tools for development

    # Go faster, off the Rails
    gem "derailed_benchmarks", "2.1.2"

    # The Listen gem listens to file modifications and notifies you about the changes. Works everywhere!
    gem "listen", "3.8.0"

    gem "spring"

    gem "spring-watcher-listen", "~> 2.0.0"

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
