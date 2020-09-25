require 'net/http'
require 'json'

namespace :app do
    namespace :locations do

        desc 'Import location entities'
        task import: :environment do
            set_account()
            default_location()
            import_continents()
            import_countries()
        end
        
        def set_account
            @account = Account.first
        end

        def default_location
            puts "-- Processing default parent location"
            Account::Location.create!(
                name: "Empty",
                level: "empty",
                parent_id: nil,
                account: @account
            )
            puts "-- Default parent location import complete"
        end

        def import_continents
            puts '-- Processing continents'
            continents = [
                {
                    name: 'Africa',
                    short_name: 'AF'
                },
                {
                    name: 'Antarctica',
                    short_name: 'AN'
                },
                {
                    name: 'Asia',
                    short_name: 'AS'
                },
                {
                    name: 'Europe',
                    short_name: 'EU'
                },
                {
                    name: 'North America',
                    short_name: 'NA'
                },
                {
                    name: 'Oceania',
                    short_name: 'OC'
                },
                {
                    name: 'South America',
                    short_name: 'SA'
                }
            ]
            
            continents.each do |continent|
                Account::Location.create!(
                    name: continent[:name],
                    short_name: continent[:short_name],
                    level: 'continent',
                    parent_id: nil,
                    account: @account
                )
            end
            puts '-- Continents import complete'
        end

        def import_countries
            puts '-- Processing countries'

            uri = URI('https://restcountries.eu/rest/v2/all?fields=name;alpha3Code;callingCodes;region;subregion;latlng;numericCode;languages;')
            res = Net::HTTP.get_response(uri)

            countries_str = res.body if res.is_a?(Net::HTTPSuccess)
            countries = JSON.parse countries_str

            countries.each do |country|
                continent = country['region']
                continent = country['subregion'] if country['region'] == 'Americas'
                continent = 'Antarctica' if country['region'] == 'Polar'
                continent = 'South America' if country['subregion'] == 'Caribbean'
                continent = 'South America' if country['subregion'] == 'Central America'
                continent = 'North America' if country['subregion'] == 'Northern America'
                
                continent_id = country['region'] == '' ? Account::Location.find_by(name: 'Empty').id : Account::Location.find_by(name: continent, level: 'continent').id

                Account::Location.create!(
                    name: country['name'],
                    short_name: country['alpha3Code'],
                    latitude: country['latlng'][0],
                    longitude: country['latlng'][1],
                    code: country['numericCode'],
                    calling_code: country['callingCodes'][0],
                    level: 'country',
                    parent_id: continent_id,
                    account: @account
                )
            end
            puts '-- Countries import complete'
        end

    end
end
