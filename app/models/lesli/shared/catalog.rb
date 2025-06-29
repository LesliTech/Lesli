
module Lesli 
    module Shared 
        class Catalog < ActiveRecord::Base
            self.abstract_class = true

            before_save :create_catalog_key

            def self.items_for(catalog, column = :name)
                self.find_by(column => catalog)&.items || [] 
            end

            private

            def create_catalog_key 
                self.key = self.name.parameterize
            end
        end
    end
end
