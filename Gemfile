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

Lesli · Ruby on Rails SaaS Development Engine.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.dev
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·
=end

source "https://rubygems.org"

# Specify your gem's dependencies in my_engine.gemspec.
gemspec

gem "puma"

gem "sqlite3"

gem "propshaft"

# Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
gem "rubocop-rails-omakase", require: false

gem "minitest-reporters"

gem "color_pound_spec_reporter"

# Code coverage
# https://github.com/simplecov-ruby/simplecov
gem "simplecov", "0.21.2", require: false

# Code coverage stats in the console
# https://github.com/chetan/simplecov-console
gem "simplecov-console", "0.9.2", require: false

gem "brakeman"

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

# Until a patch for Rails 8.1.2 (or higher) is released specifically addressing the Minitest 6 boot sequence, the most stable way to run your tests is:
#     Keep Minitest at ~> 5.0 in your Gemfile.
#     Use the standard command: bin/rails test.
gem "minitest", "~> 5.0"
