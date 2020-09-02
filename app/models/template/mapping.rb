class Template::Mapping < ApplicationRecord
    belongs_to :document,   class_name: "Template::Document",    foreign_key: "template_documents_id"
    belongs_to :variable,  class_name: "Template::Variable",    foreign_key: "template_variables_id"
end
