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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

require_relative "lib/lesli/version"

Gem::Specification.new do |spec|
    spec.name        = "lesli"
    spec.version     = Lesli::VERSION
    spec.platform    = Gem::Platform::RUBY
    spec.license     = "GPL-3.0"
    spec.authors     = ["The Lesli Development Team"]
    spec.email       = ["hello@lesli.tech"]
    spec.homepage    = "https://www.lesli.dev/"
    spec.summary     = "Ruby on Rails SaaS Development Framework."
    spec.description = "Ruby on Rails SaaS Development Framework."

    # rubygems.org use description to show the info about the gem, so it is better to use a brief
    # one line description for better understanding of the Lesli gem
    # spec.description = "Lesli is a SaaS development framework designed to build highly scalable, secure and customizable software products."

    # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
    # to allow pushing to a single host or delete this section to allow pushing to any host.
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["changelog_uri"] = "https://github.com/LesliTech/Lesli"
    spec.metadata["source_code_uri"] = "https://github.com/LesliTech/Lesli"

    spec.files = Dir.chdir(File.expand_path(__dir__)) do
        Dir["{app,config,db,lib}/**/*", "license", "Rakefile", "readme.md"]
    end
  
    # Ruby version
    spec.required_ruby_version = ">= 2.7"

    

    # · RAILS: gem, dependencies and tools

    # Rails framework
    spec.add_dependency("rails", "~> 7.0", "< 7.1")

    # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
    spec.add_dependency("sprockets-rails", "~> 3.4.2")

    # Integrate SassC-Ruby into Rails.
    spec.add_dependency("sassc-rails", "~> 2.1.2")

    # It's a small library to provide the Rails I18n translations on the Javascript.
    spec.add_dependency("i18n-js", "~> 4.2.3") 

    # Pg is the Ruby interface to the PostgreSQL RDBMS. It works with PostgreSQL 9.3 and later.
    # This gem requires the package: libpq-dev; sudo apt-get -y install libpq-dev
    spec.add_dependency("pg", "~> 1.5.3")



    # · Tools used to extend Rails functionality

    # ActiveRecord plugin allowing you to hide and restore records without actually deleting them. 
    spec.add_dependency("acts_as_paranoid", "~> 0.8.1")

    # Clean, powerful, agnostic, customizable and sophisticated paginator for Rails
    spec.add_dependency("kaminari", "~> 1.2.2")



    # · Tools used to build the Lesli Framework

    # Message utilities for the Ruby console.
    spec.add_dependency("L2", "~> 0.5.2")

    # Flexible authentication solution for Rails with Warden
    spec.add_dependency("devise", "~> 4.9.2")

    # HTTP User Agent parser
    spec.add_dependency("useragent", "~> 0.16.10")
    
    # collection of all country flags in SVG
    spec.add_dependency("flag-icons-rails", "3.4.6.1")



    # Simple greetings message
    spec.post_install_message = "Greetings from LesliTech  ❤️  Docs are available at https://www.lesli.dev/"

end
