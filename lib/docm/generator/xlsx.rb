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

            # @return [String] The path where the generated xlsx file is located
            # @param filename [String] the name of the generated file
            # @param xlsx_datasets [Array] The datasets to be recorded into the xlsx file. Each dataset
            #     represents a worksheet.
            # @param style_data [Hash] The styles to be added to the worksheet. To know more about the style
            #     format, refer to the documentation in rails/xlsx-styles
            # @param pivote_table_data [Hash] The options to add a pivote table at the final of the worksheet.
            #   {
            #       sheet_source<Integer>: The sheet from where extract the data.
            #       sheet_name<String>: The name of the sheet.
            #       rows<Array>: The rows of the pivote table.
            #       columns<Array>: The columns of the pivote table.
            #       data<Hash>: {
            #           ref: column_name,
            #           subtotal: [count, average, max, min, product, ...]
            #       }
            #       pages<Array>: The Filters of pivote table.
            #   }
            #
            # @description Generates a normal xlsx file with the content received in **xlsx_datasets** and adds
            #     the respective styles if **style_data** is received as an argument
            # @example
            #     # Imagine you want to generate a report and add it styles. You create a service that returns
            #     # the styles in XlsxReport::StyleService
            #     data = CloudHouse::Report.daily_changes(User.find(2))
            #     file_path =  Docm::Generator::Xlsx.generate(
            #         "daily_changes.xlsx",
            #         data,
            #         style_data: XlsxReport::StyleService.daily_changes
            #     )
            def self.generate(filename, xlsx_datasets, style_data: nil, pivote_table_data: nil, title: nil, summary: nil)
                style_data = {styles: {}, sheets: [{rows: []}]} unless style_data
                axlsx = Axlsx::Package.new
                workbook = axlsx.workbook

                # We take the styles sent as hash, and turn them insto workbook styles
                style_data[:styles].each do |style_name, data|
                    style_data[:styles][style_name] = workbook.styles.add_style(data)
                end

                sheet_styles = nil
                static_sheet_styles = nil

                xlsx_datasets.each_with_index do |xlsx_data, sheet_index|

                    # We will use the first sheet we find, and only change if possible when the number of sheet we are
                    # adding to the xlsx file is bigger than the :end_sheet param of the styles. We deep copy the styles
                    # to keep an original version, because the rows and columns pop elements from the arrays.
                    if (! sheet_styles) || (sheet_styles[:end_sheet] && (sheet_styles[:end_sheet] < sheet_index))

                        static_sheet_styles = (style_data[:sheets].shift || {})
                        sheet_styles = JSON.parse(static_sheet_styles.to_json).deep_symbolize_keys
                    else
                        sheet_styles = JSON.parse(static_sheet_styles.to_json).deep_symbolize_keys
                    end

                    workbook.add_worksheet(:name => xlsx_data[0]) do |sheet|

                        # If there is a title, we add it between 2 empty lines
                        if title
                            sheet.add_row
                            
                            sheet.add_row(
                                [title[:text]].concat(Array.new(title[:colspan]-1, "")),
                                style: [style_data[:styles][:title]].concat(Array.new(title[:colspan]-1, nil)),
                                height: 25
                            )
                            sheet.merge_cells(sheet.rows.last.cells[(0..(title[:colspan] - 1))])

                            sheet.add_row
                        end

                        # If there is a summary, we add it between 2 empty lines
                        if summary
                            sheet.add_row
                            
                            sheet.add_row(
                                [summary[:text]].concat(Array.new(summary[:colspan]-1, "")),
                                style: [style_data[:styles][:summary]].concat(Array.new(summary[:colspan]-1, nil)),
                                height: 20
                            )
                            sheet.merge_cells(sheet.rows.last.cells[(0..(summary[:colspan] - 1))])

                            sheet.add_row
                        end

                        # Separating headers and rows into 2 different keys is now deprecated. We should put all the
                        # information into "rows"
                        xlsx_data[1]["rows"].unshift(xlsx_data[1]["headers"])
                        row_styles = nil
                        expanded_row_styles = []

                        # Adding all the rows found in database. We continue using the same style until the index of
                        # the row we are analizying is greater than the :end_row of the style. At that moment, we move to
                        # the styles for the next row.
                        xlsx_data[1]["rows"].each_with_index do |row, row_index|
                            if (! row_styles) || (row_styles[:end_row] && (row_styles[:end_row] < row_index))
                                row_styles = sheet_styles[:rows].shift || {}
                                expanded_row_styles = self.expand_styles(row, row_styles, style_data[:styles])

                            end

                            sheet.add_row(row, style: expanded_row_styles)
                        end

                        x = self.expand_widths(sheet_styles[:widths], expanded_row_styles.length)

                        sheet.column_widths(*x)
                    end

                    # If there is a third value in the xlsx_datasets array (Array) it is supposed to be a pivot table
                    # Which allows us to have many pivot tables in the same file
                    if xlsx_data.length.eql? 3
                        axlsx.workbook.add_worksheet(:name => xlsx_data[2][:sheet_name]) do |worksheet|
                            rows_length = xlsx_datasets[sheet_index][1]["rows"].length + 1 #header
                            columns_length = xlsx_datasets[sheet_index][1]["headers"].length

                            pivot_table = Axlsx::PivotTable.new(
                                'A4', # pivote table starts at A4
                                "A1:#{column_name(columns_length)}#{rows_length}", # pivote table ends at
                                axlsx.workbook.worksheets[xlsx_data[2][:sheet_source]], # use sheet source
                            )

                            pivot_table.rows = xlsx_data[2][:rows]
                            pivot_table.columns = xlsx_data[2][:columns]
                            pivot_table.data = xlsx_data[2][:data]
                            pivot_table.pages = xlsx_data[2][:pages]
                            worksheet.pivot_tables << pivot_table
                        end
                    end
                end

                unless pivote_table_data.blank?
                    rows_length = xlsx_datasets[pivote_table_data[:sheet_source]][1]["rows"].length + 1 #header
                    columns_length = xlsx_datasets[pivote_table_data[:sheet_source]][1]["headers"].length

                    #create pivote table in a different sheet
                    axlsx.workbook.add_worksheet(:name => pivote_table_data[:sheet_name]) do |sheet|
                        pivot_table = Axlsx::PivotTable.new(
                            'A4', # pivote table starts at A4
                            "A1:#{column_name(columns_length)}#{rows_length}", # pivote table ends at
                            axlsx.workbook.worksheets[pivote_table_data[:sheet_source]], # use sheet source
                        )

                        pivot_table.rows = pivote_table_data[:rows]
                        pivot_table.columns = pivote_table_data[:columns]
                        pivot_table.data = pivote_table_data[:data]
                        pivot_table.pages = pivote_table_data[:pages]
                        sheet.pivot_tables << pivot_table
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

            # @return [Array] An array the same length as all the rows in the sheet. Each element contract_living_space_area
            #     a number representing the width of each one of the columns in the sheet.
            # @param widths [Array] Array containing the different widths of all columns within the sheet. This array should not
            #     necessarily have the same number of elements as the amount of columns within the sheet.
            # @param num_columns [Integer] The amount of columns within the sheet
            # @description Takes the array of widths and expands it, copying the last element until the array has the same size
            #     as the number of columns on the current xlsx sheet. Null values mean that the default column size will be used
            # @example
            #     # Imagine also that your current sheet has 10 columns and that widths is:
            #     # [10, 15, 20, 20, nil, 5]
            #     widths = [10, 15, 20, 20, nil, 5]
            #     expanded_widths = Docm::Generator::Xlsx.expand_widths(widths, 10)
            #     # This will return an array like this
            #     [10, 15, 20, 20, nil, 5, 5, 5, 5, 5]
            def self.expand_widths(widths, num_columns)
                widths = [] unless widths
                if widths.length < num_columns
                   widths = widths + Array.new(num_columns - widths.length, widths[-1])
                end

                return widths
            end

            # @return [Array] An array the same length as the row to be recorded, containing
            #     the respective styles for each column of the row
            # @param row [Array] Array containing the next row to be recorded into the xlsx sheet.
            #     This row is only used to determine how many columns are in the row
            # @param row_styles [Array] Array of styles that follow the format specified in docs/rails/xlsx-styles
            #     These styles contain the compacted information of the styles to be added to the columns
            # @param styles [Hash] Hash of styles as returned by Axlsx::Package.new.workbook.styles.add_style(data)
            #     The key is a name given to the style and the value is the index of the style given by Axlsx
            # @description Takes the compacted styles specified in our format and expands them into an array of numbers.
            #     Each number represents the id of a different style registed by Axlsx and indicated the style to be given to
            #     the respective worksheet column
            # @example
            #     # Imagine also that you have 3 styles in **row_styles**: {
            #     #     bold_only: {b: true},
            #     #     italic_only: {i: true},
            #     #     bg_blue: {bg_color: "93a9d7"}
            #     # }
            #     # After you register then with Axlsx, the should look like this: {{
            #     #     bold_only: 3,
            #     #     italic_only: 4,
            #     #     bg_blue: 5
            #     # }
            #     row = ["value1", "value2", "value3", "value4", "value5"]
            #     Docm::Generator::Xlsx.expand_styles(
            #         row,
            #         row_styles,[
            #             {style_name: :bold_only, end_column: 0},
            #             {style_name: :italic_only, end_column: 2},
            #             {style_name: :bg_blue, end_column: 3}
            #         ]
            #     )
            #     # The returned value of this call to the method will be
            #     # [3, 4, 4, 5, nil]
            #     # Which axlsx knows how to interpret to add the respective styles to the columns
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

            # @param index [Integer] the index of excel column
            # @example
            # column_name = Docm::Generator::XlsxPivote.column_name(10)
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
        end
    end
end
