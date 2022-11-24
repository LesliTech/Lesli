class Template::Variable < ApplicationRecord
    belongs_to :template, foreign_key: "templates_id"
    has_many :mappings, foreign_key: "template_variables_id", dependent: :destroy

    after_initialize :initialize_variable

    enum variable_type: {
        table: "table",
        table_date: "table_date",
        table_currency: "table_currency",
        method: "method"
    }, _suffix: true

    def self.options(current_user, query)
        return Template::Variable.all
    end

    def initialize_variable
        self.variable_type ||= Template::Variable.variable_types[:table]
    end

end
