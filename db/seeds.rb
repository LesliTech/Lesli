=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

puts ""; puts ""; puts "";
puts "Loading core seeds for #{Rails.env.downcase} environment"
puts "~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~"

load "#{Rails.root}/db/seed/#{Rails.env.downcase}.rb"


if Rails.application.config.lesli_settings["instance"] != "Lesli"

    # Every instance (builder module) is loaded into the platform using the same 
    # name of the engine
    instance_klass = Rails.application.config.lesli_settings["instance"][:name].safe_constantize

    # If instance account class exists
    if instance_klass
        puts ""; puts ""; puts "";
        puts "Loading seeds for builder engine"
        puts "~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~"    
        instance_klass::Engine.load_seed
    end
    
end

# exec rake standard deploy task
system "rake app:deploy:after"
