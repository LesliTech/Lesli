class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
    connects_to database: { writing: :core, reading: :core_replica }
end
