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

class Descriptor < ApplicationLesliRecord
    belongs_to :account,  foreign_key: "accounts_id",    class_name: "Account"
    has_many :privileges, foreign_key: "descriptors_id"
    has_many :activities, foreign_key: "descriptors_id"

    # this scope is needed to allow to join with deleted descriptors
    # join with deleted descriptors is needed to know which privileges we have to remove from the
    # role_privileges table when a descriptor is removed from role_describers
    has_many :descriptors_all, -> { with_deleted }, foreign_key: "descriptors_id", class_name: "Role::Descriptor"

    validates :name, presence: true

    after_create :initialize_descriptor_privileges

    def initialize_descriptor_privileges

        # assign ["show", "update"] actions from profile descriptor to the role
        if self.name == "profile"

        end
    end

    def self.list(current_user, query)
        current_user.account.descriptors
        .select(:id, :name)
        .order(:name)
    end 

    def self.index(current_user, query)

        # Get search string from query params
        search_string = query[:search].downcase.gsub(" ","%") unless query[:search].blank?

        descriptors = current_user.account.descriptors

        # Filter results by search string
        unless search_string.blank?
            descriptors = descriptors.where("(LOWER(descriptors.name) SIMILAR TO :search_string)", search_string: "%#{sanitize_sql_like(search_string, " ")}%")
        end

        descriptors = descriptors.select(:id, :name, :created_at, :updated_at)
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order("#{query[:order][:by]} #{query[:order][:dir]} NULLS LAST")

        descriptors

    end 

    def show(current_user, query)
        { 
            :id => self.id,
            :name => self.name,
            :description => self.description,
            :descriptors_id => self.descriptors_id,
            :privileges => self.privileges.select(:id, :controller, :action, :created_at)
        }
    end
    
end
