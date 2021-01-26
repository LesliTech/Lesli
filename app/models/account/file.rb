=begin

Copyright (c) 2021, all rights reserved.

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

class Account::File < ApplicationLesliRecord
    mount_uploader :attachment_s3,  AwsUploader
    mount_uploader :attachment,     LocalUploader
    

    belongs_to :account, foreign_key: "account_id"
    belongs_to :cloud_object, class_name: "::Account", foreign_key: "account_id"
end
