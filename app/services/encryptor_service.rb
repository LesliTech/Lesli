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

########    This service is used to encrypt anything we need in the whole app                       ########
########    Such as emails, IDs, names, ... use it for whatever you want to encrypt or decrypt      ########

class EncryptorService

    #   @example
    #       my_email = "test@lesli.cloud"

    #       # Use case when you would to encrypt something
    #       my_encrypted_email = EncryptorService.new_encrytor.encrypt_and_sign(my_email)
    #       puts my_encrypted_email
    #           "FhIIEK0hToXLVJN+915bsQhAOUq/9IKR0jxyL90H4EHiFQVxmxur/Hqw--xWOQdECZ9c7kO8UN--AiytpQe1ZpS58tygZPQVZA==""

    #       # Use case when you would decrypt someting that has already been encrypted
    #       decrypted_email = EncryptorService.new_encrytor.decrypt_and_verify(my_encrypted_email)
    #       puts decrypted_email
    #           "test@lesli.cloud"
    def self.new_encrytor
        len = ActiveSupport::MessageEncryptor.key_len
        
        key = ActiveSupport::KeyGenerator.new(
            Rails.application.credentials[:secret_key_base]
        ).generate_key("", len)

        return ActiveSupport::MessageEncryptor.new(key)
    end
end
