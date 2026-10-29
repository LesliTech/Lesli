# frozen_string_literal: true

require_relative "../resource/resource_generator"

module Lesli
    module Generators
        # Backwards-compatible name for the complete Lesli resource generator.
        class ScaffoldGenerator < ResourceGenerator
            source_root ResourceGenerator.source_root
        end
    end
end
