=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   Carlos Hermosilla
@license  Propietary - all rights reserved.
@version  0.1.0-alpha
@description Base abstract model for *file* core entity

=end
module CloudObject
    class File < ApplicationLesliRecord
        self.abstract_class = true
        mount_uploader :attachment, AwsUploader
        mount_uploader :attachment_local, LocalUploader
        
        belongs_to :user_creator, class_name: "::User", foreign_key: "users_id"

        # @return [User] This method will always return nil
        # @description At the current time, this is a dummy method that returns nil, so the function is_editable_by? in
        #   ApplicationLesliRecord will work without issues
        def user_main
            return nil
        end

        enum file_type: {}

        def self.options
            data_file_types = []
            self.file_types.each do |key, value|
                data_file_types.push({
                    value: key,
                    text: value
                })
            end

            {
                file_types: data_file_types
            }
        end

        def self.allowed_file_extensions
            return nil
        end

        def self.verify_file_extension(filename)
            allowed_file_extensions_ = self.allowed_file_extensions

            return true unless allowed_file_extensions_
            
            allowed_file_extensions_.each do |file_extesion|
                if filename.downcase.end_with?(file_extesion)
                    return true
                end
            end

            return false
        end

    end
end
