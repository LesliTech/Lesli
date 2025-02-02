
module Lesli
    module HtmlHelper
        def turbo_link_to body, url, html_options = {}
            link_to(body, url, class: "link", data: { turbo_frame: '_top' })
        end
    end
end
