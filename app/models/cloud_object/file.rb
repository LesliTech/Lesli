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
        mount_uploader :attachment, FileUploader

        belongs_to :user, foreign_key: "users_id"

        enum file_type: {}

        # @return [Array] An array of users, the relevant user for a task
        # @description Returns the relevant users for the task. In this case, the creator and the
        #   assigned users. This list is ordered, the first one is always the most important and will be
        #   the only one used for object level permission verification based on the role_detail field value
        # @example
        #   creator_user = User.find(1)
        #   assigned_user = User.find(2)
        #   account = Account.find(1)
        #   task = account.focus.tasks.create!(creator: creator_user, user: assigned_user, detail_attributes(....))
        #   task.relevant_users    # Will return an array with both users as the relevant users
        def relevant_users
            return [user] 
        end

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
