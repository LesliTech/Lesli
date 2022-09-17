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
    has_many :describers, foreign_key: "descriptors_id", class_name: "Role::Describer"


    def self.list(current_user, query)
        current_user.account.descriptors
        .select(:id, :name, :code, :path)
        .order(:name)
    end 

    def self.index(current_user, query)
        current_user.account.descriptors
        .select(:id, :name, :engine, :reference, :path, :created_at, :updated_at)
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order(:engine, :reference)
    end 

    def show(current_user, query)
        { 
            :id => self.id,
            :reference => self.reference,
            :engine => self.engine,
            :path => self.path,
            :name => self.name,
            :privileges => self.privileges.select(:id, :controller, :action, :created_at)
        }
    end 

end
