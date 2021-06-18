=begin

Copyright (c) 2020, all rights reserved.

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

module Docm
    module Generator
        class Xlsx
            def self.generate(filename, xlsx_datasets, style_data: nil)
                style_data = {styles: {}, sheets: {data: []}} unless style_data
                axlsx = Axlsx::Package.new
                workbook = axlsx.workbook
                
                # We take the styles sent as hash, and turn them insto workbook styles
                style_data[:styles].each do |style_name, data|
                    style_data[:styles][style_name] = workbook.styles.add_style(data)
                end

                sheet_styles = nil
                static_sheet_styles = nil

                # Creates a new excel file
                xlsx_datasets.each_with_index do |xlsx_data, sheet_index|

                    if (! sheet_styles) || (sheet_styles[:end_sheet] && (sheet_styles[:end_sheet] < sheet_index))
                        if sheet_styles && sheet_styles[:end_sheet]
                        end
                        static_sheet_styles = (style_data[:sheets].shift || {})
                        sheet_styles = JSON.parse(static_sheet_styles.to_json).deep_symbolize_keys
                    else
                        sheet_styles = JSON.parse(static_sheet_styles.to_json).deep_symbolize_keys
                    end
                    
                    workbook.add_worksheet(:name => xlsx_data[0]) do |sheet|

                        # Adding column names on the first row of the excel
                        xlsx_data[1]['rows'].unshift(xlsx_data[1]['headers'])
                        row_styles = nil
                        expanded_row_styles = []

                        # Adding all the rows found in database
                        xlsx_data[1]['rows'].each_with_index do |row, row_index|
                            if (! row_styles) || (row_styles[:end_row] && (row_styles[:end_row] < row_index))
                                row_styles = sheet_styles[:data].shift || {}
                                expanded_row_styles = self.expand_styles(row, row_styles, style_data[:styles])
                            end

                            sheet.add_row(row, style: expanded_row_styles)
                        end
                    end

                    
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

            def self.expand_styles(row, row_styles, styles)
                column_styles = row_styles[:columns] || []
                expanded_styles = []
                column_style = column_styles.shift

                row.each_with_index do |column, column_index|
                    unless column_style
                        expanded_styles.push(nil)
                        next
                    end

                    if column_style[:style_name]
                        expanded_styles.push(styles[column_style[:style_name].to_sym])
                    else
                        expanded_styles.push(nil)
                    end

                    if column_style[:end_column] && column_style[:end_column] <= column_index 
                        column_style = column_styles.shift
                    end
                end

                expanded_styles
            end
        end
    end
end    
