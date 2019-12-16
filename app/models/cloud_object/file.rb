module CloudObject
    class File < ApplicationRecord
        self.abstract_class = true

        has_one_attached :file
    end
end
