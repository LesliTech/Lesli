class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
    audited
end
