class Location < ApplicationRecord

    has_many    :sub_locations,     class_name: "Location", foreign_key: "parent_id"
    belongs_to :parent_location,    class_name: "Location", foreign_key: "parent_id", optional: true
    belongs_to :account,            class_name: "Account",  foreign_key: "accounts_id"

    enum level: {
        continent: "continent",
        country: "country",
        state: "state",
        city: "city",
        zone: "zone"
    }
end
