=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

class Account::Location < ApplicationRecord
    belongs_to  :account,         class_name: "Account",  foreign_key: "accounts_id"
    belongs_to  :parent_location, class_name: "Location", foreign_key: "parent_id", optional: true

    has_many    :sub_locations,   class_name: "Location", foreign_key: "parent_id"

    validates_presence_of :name

    enum level: {
        empty: "empty",
        continent: "continent",
        country: "country",
        region: "region",
        state: "state",
        city: "city",
        zone: "zone"
    }

    def self.list(current_user, query)
        query_filters = []

        # filter[:type] will indicate the level of the location.
        # For example, type=state,city,country
        if query[:filters][:type]
            types_filter = query[:filters][:type].split(",").map do |type|
                "'#{type}'"
            end

            query_filters.push("level in (#{types_filter.join(",")})")
        end

        if query[:filters][:search]
            query_filters.push("LOWER(name) like '%#{query[:filters][:search]}%'")
        end

        locations = current_user.account.locations.where(query_filters.join(" and "))

        if query[:pagination]
            locations = locations.order("#{query[:order][:by]} #{query[:order][:dir]} NULLS LAST")
        end

        locations
    end

    def show
        self
    end
end
