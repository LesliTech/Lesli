module Lesli
    module AnnouncementsHelper
        ANNOUNCEMENT_STYLES = {
            "info" => { icon: "info", classes: "border-info-300 bg-info-50 text-info-900" },
            "success" => { icon: "check_circle", classes: "border-success-300 bg-success-50 text-success-900" },
            "warning" => { icon: "warning", classes: "border-warning-300 bg-warning-50 text-warning-900" },
            "danger" => { icon: "error", classes: "border-danger-300 bg-danger-50 text-danger-900" }
        }.freeze

        def announcement_style(category)
            ANNOUNCEMENT_STYLES.fetch(category, ANNOUNCEMENT_STYLES.fetch("info"))
        end
    end
end
