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
    has_many :role_descriptors_all, -> { with_deleted }, foreign_key: "descriptors_id", class_name: "Role::Descriptor"

    validates :name, presence: true

    after_create :initialize_descriptor_privileges

    def initialize_descriptor_privileges

        # assign ["show", "update"] actions from profile descriptor to the role
        DescriptorService.add_profile_privileges(self) if self.name == "profile"

        DescriptorService.add_owner_privileges(self) if ["owner", "sysadmin"].include?(self.name)

    end

    def self.list(current_user, query)
        current_user.account.descriptors
        .select(:id, :name)
        .order(:name)
    end 

    def self.index(current_user, query)

        # Get search string from query params
        search_string = LC::Sql.sanitize_for_search(query[:search])

        descriptors = current_user.account.descriptors.select(
            :id,
            :name,
            :description,
            "coalesce(actions.total, 0) as privileges_count",
            LC::Date2.new.date_time.db_timestamps("descriptors")
        )

        # Count the amount of privileges assigned to every descriptor
        descriptors = descriptors.joins("
            left join  (
                select
                    count(1) as total,
                    descriptors_id
                from descriptor_privileges
                --where apga.status = TRUE
                group by descriptors_id
            ) as actions
                on actions.descriptors_id = descriptors.id
        ")
        
        # skip native descriptors
        #descriptors = descriptors.where.not("descriptors.name in (?)", ["owner", "sysadmin", "profile"])

        # Filter results by search string
        unless search_string.blank?
            descriptors = descriptors.where("(LOWER(descriptors.name) SIMILAR TO ?)", search_string)
        end

        descriptors
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order("#{query[:order][:by]} #{query[:order][:dir]} NULLS LAST")

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
