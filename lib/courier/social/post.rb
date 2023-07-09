=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module Courier
    module Social
        class Post
            
            def self.index(current_user, query)
                return {} unless defined? CloudSocial
                CloudSocial::Post.index(current_user, query)
            end
            
            def self.show(current_user, query, post_id)
                return {} unless defined? CloudSocial
                post = CloudSocial::Post.find_by_id(post_id)
                post.show(current_user)
            end
            
            def self.create(current_user, params)
                return {} unless defined? CloudSocial
                post = current_user.account.social.posts.new(params)
                post.user = current_user
                post.save!
                return post
            end
            
            def self.update(current_user, params, post_id)
                return {} unless defined? CloudSocial
                post = CloudSocial::Post.find_by_id(post_id)
                post.update(params)
                return post
            end
            
            def self.destroy(current_user, post_id)
                return {} unless defined? CloudSocial
                
                # Using the PostServices to destroy the post
                CloudSocial::PostServices.destroy(current_user, post_id)
            end
        end
    end
end
