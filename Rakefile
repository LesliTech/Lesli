require "bundler/setup"

APP_RAKEFILE = File.expand_path("test/dummy/Rakefile", __dir__)

load "rails/tasks/engine.rake"

require "bundler/gem_tasks"

desc "Run engine tests through the dummy Rails application"
task test: "app:test"
