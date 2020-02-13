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

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class Ability
    include CanCan::Ability

    def initialize(user)

        user.role.role_privileges.each do |privilege|
            module_name = privilege.privilege_object_name.gsub('/', '::',)
            module_name = module_name.gsub(/\b('?[a-z])/) { $1.capitalize }
            module_name = module_name.split('::').map{ |s| s.singularize }.join '::'
            module_name = module_name.remove("Core::").camelize

            begin
                Module.const_get(module_name) #Verify that the models exist
                module_name = module_name.constantize 
            rescue NameError
                nil
            end

            # Everything that each privilege can do
            can [:index], module_name  if privilege.privilege_index == true 
            can [:show], module_name  if privilege.privilege_show == true 
            can [:create], module_name  if privilege.privilege_create == true 
            can [:new], module_name  if privilege.privilege_new == true 
            can [:edit], module_name  if privilege.privilege_edit == true 
            can [:update], module_name  if privilege.privilege_update == true
            can [:destroy], module_name  if privilege.privilege_destroy == true
            can [:default], module_name  if privilege.privilege_default == true
            can [:empty], module_name  if privilege.privilege_empty == true
            # All the options in each engine
            can [:social_account_options, :details_options, :ticket_options, :workflow_options, 
                :workflow_options, :assignment_options], module_name  if privilege.privilege_options == true

        end
    end

end
