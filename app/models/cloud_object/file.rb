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
    class File < ApplicationRecord
        self.abstract_class = true
        mount_uploader :attachment, FileUploader

        enum file_type: {}

        def self.file_options
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

    end
end
