# WickedPDF Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `render :pdf` call.
#
# To learn more, check out the README:
#
# https://github.com/mileszs/wicked_pdf/blob/master/README.md
if Gem.loaded_specs.has_key? "wicked_pdf"
    require "wicked_pdf"

    if Rails.env.development?
        if Gem.win_platform?
            WickedPdf.config = {
                # Path to the wkhtmltopdf executable: This usually isn"t needed if using
                # one of the wkhtmltopdf-binary family of gems.
                # exe_path: "/usr/local/bin/wkhtmltopdf",
                #     or
                # exe_path: Gem.bin_path("wkhtmltopdf-binary", "wkhtmltopdf")

                # Layout file to be used for all PDFs
                # (but can be overridden in `render :pdf` calls)
                # layout: "pdf.html",
                exe_path: "C:/Program Files/wkhtmltopdf/bin/wkhtmltopdf.exe",
                enable_local_file_access: true,
                encoding: "utf8"
            }
        else
            WickedPdf.config = {
                exe_path: Gem.bin_path("wkhtmltopdf-binary", "wkhtmltopdf"),
                enable_local_file_access: true,
                encoding: "utf8"
            }
        end
    end

    if Rails.env.production?
        WickedPdf.config = {
            exe_path: Gem.bin_path("wkhtmltopdf-binary", "wkhtmltopdf"),
            enable_local_file_access: true,
            encoding: "utf8"
        }
    end
end
    