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

module Courier
    module Things
        class Product

            def self.count(current_user, query)
                return 0 if not defined? CloudThings
                CloudThings::Product.count(current_user)
            end

            def self.index(current_user, query)
                return [] unless defined? CloudThings
                CloudThings::Product.index(current_user, query)
            end

            def self.show(current_user, query, id)
                return {} unless defined? CloudThings
                current_user.account.things.products.find(id).show(current_user, query)
            end

            def self.create(current_user, params)
                return unless defined? CloudThings

                product = CloudThings::Product.new(params)
                product.account = current_user.account.things
                if product.save!
                    CloudThings::Product.log_activity_create(current_user, product)
                end

                return product
            end
        end
    end
end
