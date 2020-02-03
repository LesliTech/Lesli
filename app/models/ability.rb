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

class Ability
    include CanCan::Ability

    def initialize(user)

        can [:empty], Dashboard

        can do |action, subject_class, subject|
            user.role.role_privileges.each do |privilege|
                can privilege.privilege_index, privilege.privilege_object_name
                can privilege.privilege_create, privilege.privilege_object_name
                can privilege.privilege_new, privilege.privilege_object_name
                can privilege.privilege_edit, privilege.privilege_object_name
                can privilege.privilege_show, privilege.privilege_object_name
                can privilege.privilege_update, privilege.privilege_object_name
                can privilege.privilege_destroy, privilege.privilege_object_name
                can privilege.privilege_options, privilege.privilege_object_name
                can privilege.privilege_default, privilege.privilege_object_name
                can privilege.privilege_empty, privilege.privilege_object_name

                can [:empty], privilege.privilege_object_name
            end
        end
    end

end
