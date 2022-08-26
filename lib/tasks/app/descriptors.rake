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

            # get all the controllers path defined in the Rails routes
            controllers = LC::System::Controllers.scan
            controllers.each do |controller|

                # Build a strig with the standard name of a Rails controller,
                #   Example: "UsersControllers, CloudBell::NotificationsController"
                # sometimes we need a second split to deal with third level deep of controllers
                #   Example: "Account::Currency::ExchangeRatesController" from "account/currency/exchange_rates_controller"
                cn = controller[0].split('/')   # split the controller path by namespace
                .collect(&:capitalize)          # uppercase the first letter to match the class name convention of Rails
                .join("::")                     # join by ruby class separator for namespaces
                .split('_')                     # work with compound words like "exchange_rates"
                .collect { |x| x[0] = x[0].upcase; x } # convert ['exchange', 'rates'] to ['Exchange', 'Rates']
                .join('').concat("Controller")  # finally join the parts of the class name and concat Controller

                # Create a new instance of the controller class
                co = Object.const_get(cn)

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

                    # Register the new descriptor if does not exists
                    descriptor = account.descriptors.find_or_create_by({ 
                        :name => cn.sub('Controller','').sub('::',''),
                        :controller => cn,
                        :path => controller[0]
                    })
                    
                    # Work with the list of privileges need by the controller 
                    # to be able to work in a complete view
                    co.privileges.each do |privilege|

                        # Register the current controller into the descriptor privileges
                        descriptor.privileges.create_with({
                            :active => true
                        }).find_or_create_by({
                            :reference => "#{co.name}##{privilege[0]}", # main object that needs access to the below controllers & actions
                            :controller => cn.sub("::", "/").sub("Controller", "").downcase,
                            :action => privilege[0]
                        })

                        # Register the privileges needed by the object 
                        privilege[1].each do |ca|
                            descriptor.privileges.create_with({
                                :active => true
                            }).find_or_create_by({
                                :reference => "#{co.name}##{privilege[0]}", 
                                :controller => ca.split("#")[0].sub("::", "/").sub("Controller", "").downcase,
                                :action => ca.split("#")[1].downcase
                            })
                        end 
                    end

                end

            end

            ## SIMULATE ROLE MANAGEMENT
            Role.first.describers.create({ descriptor: Descriptor.first })

        end
    end
end
