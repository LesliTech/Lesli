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
        class Xlxs
            def self.generate filename, xlsx_datasets

                axlsx = Axlsx::Package.new

                styles_header = axlsx.workbook.styles.add_style(
                    bg_color: 'DBDBDB', sz: 14
                )

                # Creates a new excel file
                xlsx_datasets.each do |xlsx_data|

                    axlsx.workbook.add_worksheet(:name => xlsx_data[0]) do |sheet|

                        # Adding column names on the first row of the excel
                        sheet.add_row xlsx_data[1]['headers']

                        # Adding all the rows found in database
                        xlsx_data[1]['rows'].each do |row|

                            sheet.add_row row

                            # search for special data like [links]
                            #row.each_with_index do |cell, index|
                            # check if cell has hyperlink
                            #if (cell.to_s.start_with?('http'))
                            # it is to hard to add dynamic hyperlinks, because some reports contains a lot of columns
                            #column where the excel is going to insert the hyperlinks, to make this work I should add all the possibles column names here from A to XFD
                            #al = ['A','B','C'] 
                            # sheet.add_hyperlink :location => cell.to_s, :ref => "#{al[index]}#{index}"
                            #end
                            #end

                        end

                        #sheet.auto_filter = "A1:AA20"

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
        end
    end
end    
