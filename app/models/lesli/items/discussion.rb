module Lesli
    module Items
        class Discussion < ApplicationRecord
            self.abstract_class = true
            default_scope { 
                select(
                    :id, 
                    :message, 
                    :created_at,
                    LesliDate::Formatter.new.date_time.db_column('created_at')
                ).order(created_at: :desc)
            }
        end
    end
end
