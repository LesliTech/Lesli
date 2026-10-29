# frozen_string_literal: true

require_relative "lesli/resource/resource_generator"

# Provides the concise `rails generate lesli RESOURCE` command while the
# implementation remains available as `lesli:resource`.
class LesliGenerator < Lesli::Generators::ResourceGenerator
    namespace "lesli"
    source_root Lesli::Generators::ResourceGenerator.source_root
    desc "Generate a complete account-scoped resource inside a Lesli engine"
end
