class Template::Variable < ApplicationRecord
    belongs_to :template, foreign_key: "templates_id"
    has_many :mappings, foreign_key: "template_variables_id", dependent: :destroy 

    after_initialize :initialize_variable
    
    def initialize_variable
        self.variable_type ||= Template::Variable.variable_types[:table]
    end

    enum variable_type: {
        table: "table",
        method: "method"
    }, _suffix: true
end




