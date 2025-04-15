# Define source SCSS files and their corresponding CSS output paths
SASS_FILES = \
	./lib/scss/templates/application.scss:./app/assets/stylesheets/lesli/templates/application.css \
	./lib/scss/templates/public.scss:./app/assets/stylesheets/lesli/templates/public.css

# Define common SASS options
SASS_OPTS = --no-source-map --load-path=node_modules --load-path=../

# Development
build:
	npx sass $(SASS_FILES) $(SASS_OPTS)

# Watch mode for development
watch:
	npx sass $(SASS_FILES) --watch $(SASS_OPTS)

# Production build (compressed output)
production:
	npx sass $(SASS_FILES) --style=compressed $(SASS_OPTS)

# Clean generated CSS files
clean:
	rm -f ./app/assets/stylesheets/lesli/templates/*.css
	rm -f ./app/assets/stylesheets/lesli/templates/*.css.map

# Default target
.PHONY: build watch production clean 
