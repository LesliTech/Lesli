=begin
<%= File.read(Pathname.new(LESLI_CORE_PATH).join("license")).to_s.force_encoding("ASCII-8BIT") %>
=end
<% module_namespacing do -%>
class <%= class_name %> < ApplicationLesliRecord
    def self.index(current_user, {})
        []
    end

    def show(current_user, {})
        self
    end
end
<% end -%>
