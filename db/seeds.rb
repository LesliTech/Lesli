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


LC::Debug.msgc "Loading core seeds for #{Rails.env.downcase} environment"

load "#{Rails.root}/db/seed/tools.rb"

load "#{Rails.root}/db/seed/#{Rails.env.downcase}.rb"

if Rails.application.config.lesli_settings["instance"] != "Lesli"

    # Every instance (builder module) is loaded into the platform using the same 
    # name of the engine
    instance_klass = Rails.application.config.lesli_settings["instance"][:name].safe_constantize

    # If instance account class exists
    if instance_klass && instance_klass.to_s != "Lesli"
        LC::Debug.msgc "Loading seeds for builder engine"
        instance_klass::Engine.load_seed
    end
    
end

# exec rake standard deploy task
system "rake app:deploy:after"
