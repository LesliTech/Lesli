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

module Courier
    module Social
        class Post

            def self.index(current_user, query)
                return [] if not defined? CloudSocial
                CloudSocial::Post.index(current_user, query)
            end

            def self.show(current_user, post_id)
                return [] if not defined? CloudSocial
                post = CloudSocial::Post.new
                post.show(current_user, post_id)
            end

            def self.create(current_user, post_params)
                return [] if not defined? CloudSocial
                CloudSocial::Post.create(current_user, post_params)
            end

            def self.update(current_user, post_id, post_params)
                return [] if not defined? CloudSocial
                post = CloudSocial::Post.new
                post.update(current_user, post_id, post_params)
            end

        end
    end
end