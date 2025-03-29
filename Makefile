# Define source SCSS files and their corresponding CSS output paths
# SASS_FILES = \
# 	./lib/scss/templates/application.scss ./app/assets/stylesheets/lesli/templates/application.css \
# 	./lib/scss/templates/dashboard.scss ./app/assets/stylesheets/lesli/templates/dashboard.css \
# 	./lib/scss/templates/home.scss ./app/assets/stylesheets/lesli/templates/home.css

SASS_FILES = \
	./lib/scss/templates/application.scss:./app/assets/stylesheets/lesli/templates/application.css \
	./lib/scss/templates/public.scss:./app/assets/stylesheets/lesli/templates/public.css

# Define common SASS options
SASS_OPTS = --load-path=node_modules --load-path=../

# Production build (compressed output)
test:
	npx sass $(SASS_FILES) $(SASS_OPTS)

# Production build (compressed output)
build:
	npx sass $(SASS_FILES) --style=compressed $(SASS_OPTS)

# Watch mode for development
watch:
	sass $(SASS_FILES) --watch $(SASS_OPTS)

# Clean generated CSS files
clean:
	rm -f ./app/assets/stylesheets/lesli/templates/*.css
	rm -f ./app/assets/stylesheets/lesli/templates/*.css.map

# Default target
.PHONY: build watch clean test
