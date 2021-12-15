# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\1en"
#   inflect.singular /^(ox)en/i, "\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# Some methods you should use in different scenarios are
# inflect.plural to specify a different pluralization rule for a noun
# inflect.singulare to specify a different pluralization rule for a noun
# inflect.irregular to speficy nouns that do not follow the language standard (like goose and geese)
# inflect.uncountable to speficy nouns that are the same in singular and plural

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym "RESTful"
# end
ActiveSupport::Inflector.inflections do |inflect|
  
    # Leave and Leaves is an irregular noun, so we should specify it so rails can pluralize it properly
    inflect.irregular "leave", "leaves"
end
  