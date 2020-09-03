class Template::Variable < ApplicationRecord
    belongs_to :template, foreign_key: "templates_id"
    has_many :mappings, foreign_key: "template_variables_id", dependent: :destroy 

    enum variable_type: {
        project: 'projects'
    }
end




