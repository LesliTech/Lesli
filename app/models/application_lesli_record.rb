class ApplicationLesliRecord < ApplicationRecord
    self.abstract_class = true
    load_and_authorize_resource
end
