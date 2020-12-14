=begin
<%= File.read(Pathname.new(LESLI_ROOT).join("license")).to_s.force_encoding("ASCII-8BIT") %>
=end
<% module_namespacing do -%>
class <%= class_name %> < ApplicationLesliRecord
    def self.index(current_user, query)
        []
    end

    def show(current_user, query)
        self
    end
end
<% end -%>
