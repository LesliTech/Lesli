=begin
<%= File.read(Pathname.new(LESLI_ROOT).join("license")).to_s.force_encoding("ASCII-8BIT") %>
=end
<% module_namespacing do -%>
class <%= class_name %> < ApplicationRecord
end
<% end -%>
