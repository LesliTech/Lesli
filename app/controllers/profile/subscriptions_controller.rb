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
class Profile::SubscriptionsController < ApplicationLesliController

    before_action :set_builder_model, only: :options

    def index
        respond_to do |format|
            format.html {}
            format.json do
                set_builder_model

                if @builder_model && (@builder_model.respond_to? :index)
                    respond_with_successful(@builder_model.index(current_user, @query))
                else
                    respond_with_successful(Profile::Subscription.index(current_user, @query))
                end
            end
        end
    end

    def options
        if @builder_model && (@builder_model.respond_to? :options)
            respond_with_successful(@builder_model.options(current_user, @query))
        else
            respond_with_successful(Profile::Subscription.options(current_user, @query))
        end
    end

    protected

    def set_builder_model
        @builder_model = "#{Rails.application.config.lesli.dig(:info, :name)}::Profile::Subscription".safe_constantize
    end
end
