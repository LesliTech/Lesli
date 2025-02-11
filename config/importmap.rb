# Pin npm packages by running ./bin/importmap

pin "application", to: "lesli/application.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js"



#pin "chart.js", to: "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"
#pin "chart.js", to: "https://ga.jspm.io/npm:chart.js@4.5.1/dist/chart.esm.js"



# my_engine/config/importmap.rb
#pin_all_from File.expand_path("../app/assets/javascripts", __dir__)
