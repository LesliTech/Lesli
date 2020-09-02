class Template < ApplicationRecord
    belongs_to :account,    class_name: "Account",  foreign_key: "accounts_id"
    has_many :documents,   class_name: "Template::Document",    foreign_key: "templates_id"
    has_many :variables,    class_name: "Template::Variable",    foreign_key: "templates_id"
end
