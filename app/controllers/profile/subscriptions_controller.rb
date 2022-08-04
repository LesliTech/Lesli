=begin

Copyright (c) 2021, all rights reserved.

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
        @builder_model = "#{Rails.application.config.lesli[:info][:name]}::Profile::Subscription".safe_constantize
    end
end
