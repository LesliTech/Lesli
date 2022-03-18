class Axlsx::PivotTable
    alias_method :orig_to_xml_string, :to_xml_string # give an alias to base method

    # @return [String]
    # There is an issue with caxlsx gem when two data columns are added to pivote table
    # This function replaces parts of the string to generate the file correctly.
    def to_xml_string(zip = "")
        str = ""
        orig_to_xml_string(str)

        str.gsub!(
            '<colItems count="1"><i/></colItems>',
            '<colFields count="1"><field x="-2"/></colFields>',
        )

        str.gsub!(
            'dataOnRows="1"',
            "",
        )

        zip << str
    end
end
