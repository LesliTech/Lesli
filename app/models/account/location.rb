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
