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

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module Docm
    module Generator
        class XlxsPivote

            # @param index [Integer] the index of excel column
            # @example
            # column_name = Docm::Generator::XlxsPivote.column_name(10)
            # puts column_name 
            # will print something like: 'J'
            def self.column_name index
                dividend = index
                max_index = 26 #length of alphabet
                offset = 65 #ascii code of A
                modulo = 0
                column_name = ""

                while (dividend > 0)
                    modulo = (dividend - 1) % max_index
                    column_name = (offset + modulo).chr + column_name
                    dividend = (dividend - modulo) / max_index
                end

                return column_name
            end

            # @param filenmae [String] The filename of the woorkbook
            # @param xlsx_datasets [Object] Contains rows and headers of each sheet
            # @param pivote_table [Object] Contains options to generate pivote table
            # @example
            # xlsx_datasets = [
            #                     [
            #                         "Information", 
            #                         { 
            #                             headers: [:name, :year, :sales, :city],
            #                             rows: [["Diego", 1997, 20, "Guatemala"],
            #                                    ["Luis", 1990, 12, "Costa Rica"],
            #                                    ["Carlos", 1994, 10, "USA"],
            #                                    ["Diego", 1997, 20, "Nicaragua"]]
            #                         }
            #                     ]
            #                 ]
            # pivote_table = {
            #     sheetname: "Summary",
            #     rows: ["name"],
            #     columns: ["year"],
            #     data: [{:ref => "sales", :subtotal => "count"}],
            #     pages: ["city"]
            # }
            # 
            # Docm::Generator::XlxsPivote.generate(
            #     "report", 
            #     xlsx_datasets, 
            #     pivote_table
            # )
            def self.generate filename, xlsx_datasets, pivote_table

                axlsx = Axlsx::Package.new

                rows_length = 0
                columns_length = 0

                xlsx_datasets.each do |xlsx_data|
                    axlsx.workbook.add_worksheet(:name => xlsx_data[0]) do |sheet|

                        rows_length = xlsx_data[1]["rows"].length + 1 #header
                        columns_length = xlsx_data[1]["headers"].length

                        sheet.add_row xlsx_data[1]['headers']
                        xlsx_data[1]['rows'].each do |row|
                            sheet.add_row row
                        end
                    end
                end

                #create pivote table in different sheet
                axlsx.workbook.add_worksheet(:name => pivote_table[:sheetname]) do |sheet|
                    pivot_table = Axlsx::PivotTable.new 'A4', "A1:#{column_name(columns_length)}#{rows_length}", axlsx.workbook.worksheets[0]
                    pivot_table.rows = pivote_table[:rows]
                    pivot_table.columns = pivote_table[:columns]
                    pivot_table.data = pivote_table[:data]
                    pivot_table.pages = pivote_table[:pages]
                    sheet.pivot_tables << pivot_table
                end

                # Saving excel file on the server disk for every user
                file_path = "#{Rails.root}/public/tmp/reports/"

                # Rename the file adding the generation date
                file_name = "#{(DateTime.now).strftime("%Y.%m.%d-%H.%M")}_#{filename}.xlsx"

                FileUtils.rm_rf(file_path + file_name)

                # generate folder structure if it does not exist
                FileUtils.mkdir_p(file_path) unless File.directory?(file_path)

                axlsx.use_shared_strings = true

                # Generate the final excel
                axlsx.serialize(file_path + file_name)

                # return file path to send/download to the user
                file_path + file_name
            end
        end
    end
end    
