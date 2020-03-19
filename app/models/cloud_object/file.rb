module CloudObject
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
    class File < ApplicationRecord
        self.abstract_class = true
        has_one_attached :file

        enum file_type: {
            approval: "approval",
            customer_data: "customer_data",
            datenbanken_migration: "datenbanken_migration",
            generated_document: "generated_document",
            immo_private_maintenance_servicing: "immo_private_maintenance_servicing",
            immo_private_plans_floor_plans: "immo_private_plans_floor_plans",
            immo_private_supply_and_service_contracts: "immo_private_supply_and_service_contracts",
            immo_public_cadastre: "immo_public_cadastre",
            immo_public_land_register_extract: "immo_public_land_register_extract",
            immo_public_property_tax_and_unit_value: "immo_public_property_tax_and_unit_value",
            kop_doc: "kop_doc",
            mark_navigator_report: "mark_navigator_report", #marktnavigator_bericht
            motivation: "motivation",
            notary_approval_declaration: "notary_approval_declaration",
            notary_document: "notary_document",
            notary_sign_off_from_board: "notary_sign_off_from_board",
            notary_version: "notary_version",
            other: "other",
            property_owner_billing: "property_owner_billing",
            property_owner_correspondence: "property_owner_correspondence",
            property_owner_insurance: "property_owner_insurance",
            property_owner_payments: "property_owner_payments",
            property_owner_property_pictures: "property_owner_property_pictures",
            property_owner_way: "property_owner_way",
            purchase_contract: "purchase_contract",
            real_estate_appraisal: "real_estate_appraisal", #immobiliengutachte
            template: "template",
            xls_sheet_upload: "xls_sheet_upload" #xls_sheet_hochladen
        }

        def self.file_options
            data_file_types = []
            self.file_types.each do |key, value|
                data_file_types.push({
                    value: key,
                    text: value.humanize
                })
            end

            {
                file_types: data_file_types
            }
        end
    end
end
