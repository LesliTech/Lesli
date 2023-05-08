=begin

Copyright (c) 2023, all rights reserved.

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

L2.br(4)


L2.info("Loading seeds for #{Rails.env.downcase} environment")


L2.br

# including tools for seeders
load Rails.root.join("db", "seed", "tools.rb")


# loading core seeders
load Rails.root.join("db", "seed", "#{Rails.env.downcase}.rb")


# loading engine seeders
Rails.application.config.lesli.dig(:engines).each do |engine|

    # every instance (builder module) is loaded into the platform using the same name of the engine
    instance_klass = engine[:name].safe_constantize

    L2.msg(
        "Loading seeds for #{instance_klass} environment", 
        "Version: #{instance_klass::VERSION}", 
        "Build: #{instance_klass::BUILD}"
    )

    # dynamic load seeds from installed engines
    instance_klass::Engine.load_seed
end


# exec maintenance tasks
Rake.application.invoke_task("app:maintenance")


L2.cow("Seed process completed!")
