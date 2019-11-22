=begin
Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

load "#{Rails.root}/db/seed/#{Rails.env.downcase}.rb"

# Loading engine seeds dymanically
CloudDriver::Engine.load_seed if defined?(CloudDriver)
CloudBooks::Engine.load_seed if defined?(CloudBooks)
CloudPanel::Engine.load_seed if defined?(CloudPanel)
CloudTeam::Engine.load_seed if defined?(CloudTeam)
CloudLock::Engine.load_seed if defined?(CloudLock)
CloudBell::Engine.load_seed if defined?(CloudBell)
CloudHelp::Engine.load_seed if defined?(CloudHelp)
CloudKb::Engine.load_seed if defined?(CloudKb)
