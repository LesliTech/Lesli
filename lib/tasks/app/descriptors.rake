=begin

Copyright (c) 2022, all rights reserved.

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

namespace :app do
    namespace :descriptors do

        desc "Build descriptors and privileges according to the app controllers"
        task build: :environment do

            LC::Debug.msg("Registering new Descriptors")

            # get all the engines, controllers and actions
            engines = LC::System::Controllers.scan2

            engines.each do |engine, controllers|

                controllers.each do |controller, actions|

                    # Build a strig with the standard name of a Rails controller,
                    #   Example: "UsersControllers, CloudBell::NotificationsController"
                    # sometimes we need a second split to deal with third level deep of controllers
                    #   Example: "Account::Currency::ExchangeRatesController" from "account/currency/exchange_rates"
                    cn = controller.split('/')   # split the controller path by namespace
                    .collect(&:capitalize)          # uppercase the first letter to match the class name convention of Rails
                    .join("::")                     # join by ruby class separator for namespaces
                    .split('_')                     # work with compound words like "exchange_rates"
                    .collect { |x| x[0] = x[0].upcase; x } # convert ['exchange', 'rates'] to ['Exchange', 'Rates']
                    .join('').concat("Controller")  # finally join the parts of the class name and concat Controller

                    # Validate that the class exists
                    # sometimes a bad or wrong route can misspell a controller name
                    next unless Object.const_defined?(cn)

                    # Create a new instance of the controller class
                    co = Object.const_get(cn).new

                    # Check if the controller has privileges defined, this must be a public class method 
                    # defined in the controller. 
                    #example: 
                    #   def self.privileges
                    #       {
                    #           list: ["UsersController#index"]
                    #       }
                    #   end
                    next unless co.methods.include?(:privileges)

                    # Register descriptors and privileges for all the accounts
                    Account.all.each do |account|

                        # Work with the list of privileges need by the controller 
                        # to be able to work in a complete view
                        co.privileges.each do |action, privileges|

                            next unless [:index, :show, :new, :edit, :create, :update, :destroy, :search].include?(action)

                            # controller name for humans, ready to be translated by babel
                            controller_name = "#{cn.sub('Controller','').sub('::','')}#{action.capitalize}".underscore.sub('/','_')

                            # controller path like the route paths build by rails
                            controller_path = cn.sub("::", "/").sub("Controller", "").underscore

                            # Register the new descriptor if it does not exists
                            # the name of the descriptor is prepared to be translated with babel
                            descriptor = account.descriptors.create_with({
                                :name => controller_name,
                                :reference => cn
                            }).find_or_create_by({ 
                                :controller => controller,
                                :action => action,
                                :engine => engine
                            }) 

                            # We must assign all the descriptors to the owner role
                            account.roles.find_by(name: 'owner').describers.find_or_create_by({
                                descriptor: descriptor
                            })
                            
                            LC::Debug.msgc("New descriptor created: #{descriptor.name}") if descriptor.new_record?

                            # Register the current controller into the descriptor privileges, so the role grants
                            # permissions to render the requested page as html and as json
                            descriptor.privileges.find_or_create_by({
                                :controller => controller_path,
                                :action => action,
                                :form => "html"
                            })

                            # register the same privilege for api requests
                            descriptor.privileges.find_or_create_by({
                                :controller => controller_path,
                                :action => action,
                                :form => "json"
                            })

                            # Register the privileges needed by the object and related to the controller
                            # the controller can register requested privileges in two ways:
                            #   - ResourceController#action
                            #   - action (from the same controller)
                            privileges.each do |privilege|

                                # check if is privilege from external controller 
                                if privilege.include?('#')
                                    privilege_controller = privilege.split("#")[0].sub("::", "/").sub("Controller", "").underscore
                                    privilege_action = privilege.split("#")[1].downcase
                                else 
                                    # here we are working with the second scenario, the controller is registering
                                    # privilege for an action from the same controller
                                    privilege_controller = controller
                                    privilege_action = privilege
                                end

                                # register the desire privilege for the controller
                                descriptor.privileges.find_or_create_by({
                                    :controller => privilege_controller,
                                    :action => privilege_action,
                                    :form => "json"
                                })
                            end 

                        end
                    end
                end
            end

            # Synchronize the descriptor privileges with the role privilege cache table 
            LC::Debug.msg("Synchronize privileges")
            RolePrivilegesService.new.synchronize_privileges

        end
    end
end
