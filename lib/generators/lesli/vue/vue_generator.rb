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

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end


# · 
require "#{Rails.root}/lib/generators/application_lesli_generator.rb"


# · 
class Lesli::VueGenerator < ApplicationLesliGenerator
    source_root File.expand_path("templates", __dir__)

    def generator
        L2.msg "Generating Lesli vue application"
    end

    def generate_stores
        template("store_js.template", @vue[:path_store])
    end

    def generate_apps 
        template("index_js.template", @vue[:path_apps].join("index.vue"))
        template("show_js.template", @vue[:path_apps].join("show.vue"))
        template("edit_js.template", @vue[:path_apps].join("edit.vue"))
        template("new_js.template", @vue[:path_apps].join("new.vue"))
    end

    def generate_components 
        template("form_vue.template", @vue[:path_components].join("form.vue"))
    end

    def generate_application 
        template("application_js.template", @vue[:path_base].join("application.js"))
    end
end
