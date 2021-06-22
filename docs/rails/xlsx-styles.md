# Xsxl File Generator Styles Format
The platform uses the class **Docm::Generator::Xlsx** to generate xlsx files and reports. In order to add styles to those reports, we have created a new standard that is both compact and easy to use. Note that the styles you want to give to the data are completely independant from the data itself, so old reports and reports with no styles will need no changes at all with this new standard.

## Were to define the styles
The hash containing your styles should be returned when calling a method defined in a service. Your service must be defined in *lesli/engines/YOUR\_BUILDER\_ENGINE/app/services/YOUR\_BUILDER\_ENGINE/xlsx_report/style_service.rb*, there you must define a method with the same name as the report you want to generate. This method will return the hash containing your custom styles.

## The format of the styles hash
The hash you must return should contain the following keys: **:styles** and **:sheets**. The **:styles** value is itself a key/value hash that contains in the key, any symbol you want that will identify each style from all the others, and in the value, another hash, this time, containing the styles of the cell as specified by th **Axlsx** documentation. The second key (**:sheets**) contains an array. Each element of an array contains information on how to format one or more sheets of your xlsx file.  


### The :sheets array
Each element in the **:sheets** array is a hash, with 2 main keys: **:end_sheet** and **:rows**. The key **:end_sheet** contains a number; the index of the sheet in which you will stop using these stylesheet and move to the next one (for example, if it's 2, you will use the first stylesheet for the sheets number 0, number 1 and number 3). Note that if the key **:end_sheet** is **nil**, that means that this stylesheet will be used for all the sheets in the xlsx file that don't have styles yet. The second key **:rows**, is an array, this time containing the styles of each row of the sheet.  

### The :rows array
Each element of the **:rows** arrays is a hash, with 2 main keys: **:end_row** and **:columns**. The key **:end_row** contains a number; the index of the row in which you will stop using these styles and move to the next ones (for example, if it's 0, you will use the first set of styles only for the first row, before moving to the second set of styles). Note that if the key **:end_row** is **nil**, that means that these styles will be used for all the rows in the sheet that don't have styles yet. The second key **:columns** is an array, this time containing the styles for each column if the row.  

### The :columns array
Each element of the **:columns** array is a hash, with 2 main keys: **:end_column** and **:style_name**, the key **:end_column** contains a number; the index of the column in which you will stop using this style and move to the next one (for example, if it's 1, you will use this style for 2 columns before moving to the next style). Note that if the key **:end column** is **ni**, that means that this style will be used for all the columns in the row that don't have a style yet. The second key **:style_name** is a symbol that has the name of one of the styles defined at the begining of the original hash, and it represents the style to be added to the column. 


## Example
```ruby
{
    styles: {
        bold_only: {b: true},
        italic_only: {i: true},
        percentage: {num_fmt: Axlsx::NUM_FMT_PERCENT},
        bg_grey: {bg_color: "d3d3d3"},
        bg_blue: {bg_color: "93a9d7"}
    },
    sheets: [
        {
            end_sheet: 0,
            rows: [
                {
                    end_row: 0, columns: [
                        {style_name: :bold_only}
                    ]
                },{
                    end_row: 1, columns: [
                        {style_name: :bold_only, end_column: 0},
                        {style_name: :bg_grey}
                    ]
                },{
                    end_row: 8, columns: []
                },{
                    end_row: 9,
                    columns: [
                        {style_name: :bold_only, end_column: 0},
                        {style_name: :bg_grey}
                    ]
                },{
                    end_row: 15, columns: [
                        {style_name: :italic_only, end_column: 0},
                        {style_name: :percentage}
                    ]
                },{
                    end_row: 16, columns: []
                },{
                    end_row: 17, columns: [
                        {style_name: :bold_only, end_column: 0},
                        {style_name: :bg_grey}
                    ]
                },{
                    end_row: 23, columns: [
                        {style_name: :italic_only, end_column: 0},
                        {}
                    ]
                },{
                    end_row: 24, columns: [
                        {style_name: :italic_only, end_column: 0},
                        {style_name: :percentage}
                    ]
                }
            ]
        },{
            rows: [
                {
                    end_row: 0, columns: [
                        {style_name: :bg_blue}
                    ]
                }
            ]
        }
    ]
}
```

## How to add styles to reports
To add styles to existing or new reports, it is very simple. Once you have the data, you must call the **generate** function of **Docm::Generator::Xlsx** adding an extra optional param *:style_data*. For example

```ruby
data = [] # You get the date here
Docm::Generator::Xlsx.generate(
    "my_report.xlsx",
    data,
    style_data: Engine::XlsxReport::StyleService.my_report_name
)
```
