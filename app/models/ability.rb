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
    end

    def initialize2(user)

        can [:empty], Dashboard

        can do |action, subject_class, subject|

            user.role.role_privileges.each do |privilege|

                can privilege.privilege_get.to_sym, privilege.privilege_model.constantize
                can [:empty], privilege.privilege_model.constantize

                if privilege.privilege_model.nil?
                    can privilege.privilege_get.to_sym, privilege.privilege_model.constantize
                else
                    can permission.action.to_sym, permission.subject_class.constantize, id: permission.subject_id
                end

            end

        end

    end
end
