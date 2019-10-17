class ApplicationLesliRecord < ApplicationRecord
    self.abstract_class = true
    audited
end
