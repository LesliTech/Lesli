# WickedPDF Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `render :pdf` call.
#
# To learn more, check out the README:
#
# https://github.com/mileszs/wicked_pdf/blob/master/README.md
if Gem.loaded_specs.has_key?("wicked_pdf")
    require "wicked_pdf"

    # path to the executable binary of wkhtmltopdf installed through
    wkhtmltopdf_exe_path = Gem.bin_path("wkhtmltopdf-binary", "wkhtmltopdf")

    # path to the binary for windows OS
    wkhtmltopdf_exe_path = "C:/Program Files/wkhtmltopdf/bin/wkhtmltopdf.exe" if Gem.win_platform?

    # 
    WickedPdf.config = {
        exe_path: wkhtmltopdf_exe_path,
        enable_local_file_access: true,
        encoding: "utf8",
        layout: "pdf"
    }
end
    