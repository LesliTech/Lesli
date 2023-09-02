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

require_relative "lib/lesli/version"

Gem::Specification.new do |spec|
    spec.name        = "lesli"
    spec.version     = Lesli::VERSION
    spec.authors     = ["The Lesli Development Team"]
    spec.email       = ["hello@lesli.tech"]
    spec.homepage    = "https://www.lesli.dev/"
    spec.summary     = "Ruby on Rails SaaS development platform."
    spec.description = "Lesli provides all the necessary tools to build your SaaS, empowering you and your team to focus on business and what makes your software special. "

    # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
    # to allow pushing to a single host or delete this section to allow pushing to any host.
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/LesliTech/Lesli"
    spec.metadata["changelog_uri"] = "https://github.com/LesliTech/Lesli"

    spec.files = Dir.chdir(File.expand_path(__dir__)) do
        Dir["{app,config,db,lib}/**/*", "license", "Rakefile", "readme.md", "lesli.yml"]
    end
  
    spec.required_ruby_version = ">= 2.7.2"
  
    # · RAILS: gem, dependencies and tools

    # Rails framework

    spec.add_dependency "rails", "~> 7"

    # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
    spec.add_dependency "sprockets-rails", "3.4.2"

    # Integrate SassC-Ruby into Rails.
    spec.add_dependency "sassc-rails", "2.1.2"

    # A set of common locale data and translations to internationalize and/or localize your Rails applications.
    spec.add_dependency "rails-i18n", "7.0.6"

    # It's a small library to provide the Rails I18n translations on the Javascript.
    # We must stick to the version 3 due version 4 changed completed the behavior of
    # the locale files creation for the frontend
    spec.add_dependency "i18n-js", "3.9.2" # "4.2.3"

    # · RAILS: gem, dependencies and tools

    # Pg is the Ruby interface to the PostgreSQL RDBMS. It works with PostgreSQL 9.3 and later.
    spec.add_dependency "pg", "1.5.3"

    # · Tools used to build the LESLI Platform

    # Message utilities for the Ruby console.
    spec.add_dependency "L2", "0.5.2"

    # Flexible authentication solution for Rails with Warden
    spec.add_dependency "devise", "4.9.2"

    # Code analyzer & formatter for Ruby apps
    spec.add_development_dependency "rubocop", "1.56.2"
end
