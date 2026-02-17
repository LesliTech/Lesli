=begin

Lesli

Copyright (c) 2025, Lesli Technologies, S. A.

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

Made with ♥ by LesliTech
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
    spec.license     = "GPL-3.0-or-later"
    spec.authors     = ["The Lesli Development Team"]
    spec.email       = ["hello@lesli.tech"]
    spec.homepage    = "https://www.lesli.dev/"
    spec.summary     = "Ruby on Rails SaaS Development Framework."
    spec.description = <<~DESC
        Lesli is a SaaS development framework designed to build highly scalable, 
        secure and customizable software products.
    DESC

    # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
    # to allow pushing to a single host or delete this section to allow pushing to any host.
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"]       = spec.homepage
    spec.metadata["changelog_uri"]      = "https://github.com/LesliTech/Lesli/releases"
    spec.metadata["source_code_uri"]    = "https://github.com/LesliTech/Lesli"
    spec.metadata["bug_tracker_uri"]    = "https://github.com/LesliTech/Lesli/issues"
    spec.metadata["documentation_uri"]  = "https://www.lesli.dev/lesli/"

    spec.files = Dir.chdir(File.expand_path(__dir__)) do
        Dir["{app,config,db,lib}/**/*", "license", "Rakefile", "readme.md"]
    end


    # Ruby version
    spec.required_ruby_version = ">= 3.2"


    # · RAILS: gem, dependencies and tools

    # Rails framework
    spec.add_dependency("rails", "~> 8.1")

    # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
    spec.add_dependency("turbo-rails", "~> 2.0")

    # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
    spec.add_dependency("importmap-rails", "~> 2.2")


    # · Tools used to extend Rails functionality

    # ActiveRecord plugin allowing you to hide and restore records without actually deleting them. 
    spec.add_dependency("acts_as_paranoid", "~> 0.11.0")

    # Clean, powerful, agnostic, customizable and sophisticated paginator for Rails
    spec.add_dependency("kaminari", "~> 1.2.2")


    # · Tools used to add Rails functionality

    # Flexible authentication solution for Rails with Warden
    spec.add_dependency("devise", "~> 5.0")


    # · Tools used to build the Lesli Framework

    # Datetime formatter and SQL-safe utilities for Rails, part of the LesliSystem
    spec.add_dependency("lesli_date", "~> 0.1")

    # Reusable View Components for The Lesli Framework 
    spec.add_dependency("lesli_view", "~> 1.0.0")

    # Reusable View Components for The Lesli Framework 
    spec.add_dependency("lesli_assets", "~> 1.0")

    # Core System Utilities for The Lesli Framework.
    spec.add_dependency("lesli_system", "~> 1.0.0")

    # Message utilities for the Ruby console.
    spec.add_dependency("L2", "~> 0.6")


    # Simple greetings message
    spec.post_install_message = "Greetings from LesliTech  ❤️  Docs are available at https://www.lesli.dev/"

end
