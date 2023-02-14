=begin
Copyright (c) 2021, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·
=end

class Account::LocationService

    def initialize(resource)
        @account = resource
    end

    def set_locations
        self.default_location()
        self.import_continents()
        self.import_countries()
    end


    def default_location

        Account::Location.find_or_create_by!(
            name: "Empty",
            level: "empty",
            parent_id: nil,
            account: @account
        )

    end

    def import_continents

        continents = [{
            name: 'Africa',
            short_name: 'AF'
        },{
            name: 'Antarctica',
            short_name: 'AN'
        },{
            name: 'Asia',
            short_name: 'AS'
        },{
            name: 'Europe',
            short_name: 'EU'
        },{
            name: 'North America',
            short_name: 'NA'
        },{
            name: 'Oceania',
            short_name: 'OC'
        },{
            name: 'South America',
            short_name: 'SA'
        }]

        continents.each do |continent|
            Account::Location.find_or_create_by!(
                name: continent[:name],
                short_name: continent[:short_name],
                level: 'continent',
                parent_id: nil,
                account: @account
            )
        end

    end

    def import_countries

        countries = [{
            name: "Afghanistan",
            short_name: "AFG",
            latitude: "33",
            longitude: "65",
            code: "4",
            calling_code: "93",
            continent: "Asia"
        },{
            name: "Åland Islands",
            short_name: "ALA",
            latitude: "60.116667",
            longitude: "19.9",
            code: "248",
            calling_code: "358",
            continent: "Europe"
        },{
            name: "Albania",
            short_name: "ALB",
            latitude: "41",
            longitude: "20",
            code: "8",
            calling_code: "355",
            continent: "Europe"
        },{
            name: "Algeria",
            short_name: "DZA",
            latitude: "28",
            longitude: "3",
            code: "12",
            calling_code: "213",
            continent: "Africa"
        },{
            name: "American Samoa",
            short_name: "ASM",
            latitude: "-14.33333333",
            longitude: "-170",
            code: "16",
            calling_code: "1684",
            continent: "Oceania"
        },{
            name: "Andorra",
            short_name: "AND",
            latitude: "42.5",
            longitude: "1.5",
            code: "20",
            calling_code: "376",
            continent: "Europe"
        },{
            name: "Angola",
            short_name: "AGO",
            latitude: "-12.5",
            longitude: "18.5",
            code: "24",
            calling_code: "244",
            continent: "Africa"
        },{
            name: "Anguilla",
            short_name: "AIA",
            latitude: "18.25",
            longitude: "-63.16666666",
            code: "660",
            calling_code: "1264",
            continent: "South America"
        },{
            name: "Antarctica",
            short_name: "ATA",
            latitude: "-74.65",
            longitude: "4.48",
            code: "10",
            calling_code: "672",
            continent: "Antarctica"
        },{
            name: "Antigua and Barbuda",
            short_name: "ATG",
            latitude: "17.05",
            longitude: "-61.8",
            code: "28",
            calling_code: "1268",
            continent: "South America"
        },{
            name: "Argentina",
            short_name: "ARG",
            latitude: "-34",
            longitude: "-64",
            code: "32",
            calling_code: "54",
            continent: "South America"
        },{
            name: "Armenia",
            short_name: "ARM",
            latitude: "40",
            longitude: "45",
            code: "51",
            calling_code: "374",
            continent: "Asia"
        },{
            name: "Aruba",
            short_name: "ABW",
            latitude: "12.5",
            longitude: "-69.96666666",
            code: "533",
            calling_code: "297",
            continent: "South America"
        },{
            name: "Australia",
            short_name: "AUS",
            latitude: "-27",
            longitude: "133",
            code: "36",
            calling_code: "61",
            continent: "Oceania"
        },{
            name: "Austria",
            short_name: "AUT",
            latitude: "47.33333333",
            longitude: "13.33333333",
            code: "40",
            calling_code: "43",
            continent: "Europe"
        },{
            name: "Azerbaijan",
            short_name: "AZE",
            latitude: "40.5",
            longitude: "47.5",
            code: "31",
            calling_code: "994",
            continent: "Asia"
        },{
            name: "Bahamas",
            short_name: "BHS",
            latitude: "24.25",
            longitude: "-76",
            code: "44",
            calling_code: "1242",
            continent: "South America"
        },{
            name: "Bahrain",
            short_name: "BHR",
            latitude: "26",
            longitude: "50.55",
            code: "48",
            calling_code: "973",
            continent: "Asia"
        },{
            name: "Bangladesh",
            short_name: "BGD",
            latitude: "24",
            longitude: "90",
            code: "50",
            calling_code: "880",
            continent: "Asia"
        },{
            name: "Barbados",
            short_name: "BRB",
            latitude: "13.16666666",
            longitude: "-59.53333333",
            code: "52",
            calling_code: "1246",
            continent: "South America"
        },{
            name: "Belarus",
            short_name: "BLR",
            latitude: "53",
            longitude: "28",
            code: "112",
            calling_code: "375",
            continent: "Europe"
        },{
            name: "Belgium",
            short_name: "BEL",
            latitude: "50.83333333",
            longitude: "4",
            code: "56",
            calling_code: "32",
            continent: "Europe"
        },{
            name: "Belize",
            short_name: "BLZ",
            latitude: "17.25",
            longitude: "-88.75",
            code: "84",
            calling_code: "501",
            continent: "South America"
        },{
            name: "Benin",
            short_name: "BEN",
            latitude: "9.5",
            longitude: "2.25",
            code: "204",
            calling_code: "229",
            continent: "Africa"
        },{
            name: "Bermuda",
            short_name: "BMU",
            latitude: "32.33333333",
            longitude: "-64.75",
            code: "60",
            calling_code: "1441",
            continent: "North America"
        },{
            name: "Bhutan",
            short_name: "BTN",
            latitude: "27.5",
            longitude: "90.5",
            code: "64",
            calling_code: "975",
            continent: "Asia"
        },{
            name: "Bolivia (Plurinational State of)",
            short_name: "BOL",
            latitude: "-17",
            longitude: "-65",
            code: "68",
            calling_code: "591",
            continent: "South America"
        },{
            name: "Bonaire Sint Eustatius and Saba",
            short_name: "BES",
            latitude: "12.15",
            longitude: "-68.266667",
            code: "535",
            calling_code: "5997",
            continent: "South America"
        },{
            name: "Bosnia and Herzegovina",
            short_name: "BIH",
            latitude: "44",
            longitude: "18",
            code: "70",
            calling_code: "387",
            continent: "Europe"
        },{
            name: "Botswana",
            short_name: "BWA",
            latitude: "-22",
            longitude: "24",
            code: "72",
            calling_code: "267",
            continent: "Africa"
        },{
            name: "Bouvet Island",
            short_name: "BVT",
            latitude: "-54.43333333",
            longitude: "3.4",
            code: "74",
            calling_code: "",
        },{
            name: "Brazil",
            short_name: "BRA",
            latitude: "-10",
            longitude: "-55",
            code: "76",
            calling_code: "55",
            continent: "South America"
        },{
            name: "British Indian Ocean Territory",
            short_name: "IOT",
            latitude: "-6",
            longitude: "71.5",
            code: "86",
            calling_code: "246",
            continent: "Africa"
        },{
            name: "United States Minor Outlying Islands",
            short_name: "UMI",
            latitude: nil,
            longitude: nil,
            code: "581",
            calling_code: "",
            continent: "North America"
        },{
            name: "Virgin Islands (British)",
            short_name: "VGB",
            latitude: "18.431383",
            longitude: "-64.62305",
            code: "92",
            calling_code: "1284",
            continent: "South America"
        },{
            name: "Virgin Islands (U.S.)",
            short_name: "VIR",
            latitude: "18.34",
            longitude: "-64.93",
            code: "850",
            calling_code: "1 340",
            continent: "South America"
        },{
            name: "Brunei Darussalam",
            short_name: "BRN",
            latitude: "4.5",
            longitude: "114.6666667",
            code: "96",
            calling_code: "673",
            continent: "Asia"
        },{
            name: "Bulgaria",
            short_name: "BGR",
            latitude: "43",
            longitude: "25",
            code: "100",
            calling_code: "359",
            continent: "Europe"
        },{
            name: "Burkina Faso",
            short_name: "BFA",
            latitude: "13",
            longitude: "-2",
            code: "854",
            calling_code: "226",
            continent: "Africa"
        },{
            name: "Burundi",
            short_name: "BDI",
            latitude: "-3.5",
            longitude: "30",
            code: "108",
            calling_code: "257",
            continent: "Africa"
        },{
            name: "Cambodia",
            short_name: "KHM",
            latitude: "13",
            longitude: "105",
            code: "116",
            calling_code: "855",
            continent: "Asia"
        },{
            name: "Cameroon",
            short_name: "CMR",
            latitude: "6",
            longitude: "12",
            code: "120",
            calling_code: "237",
            continent: "Africa"
        },{
            name: "Canada",
            short_name: "CAN",
            latitude: "60",
            longitude: "-95",
            code: "124",
            calling_code: "1",
            continent: "North America"
        },{
            name: "Cabo Verde",
            short_name: "CPV",
            latitude: "16",
            longitude: "-24",
            code: "132",
            calling_code: "238",
            continent: "Africa"
        },{
            name: "Cayman Islands",
            short_name: "CYM",
            latitude: "19.5",
            longitude: "-80.5",
            code: "136",
            calling_code: "1345",
            continent: "South America"
        },{
            name: "Central African Republic",
            short_name: "CAF",
            latitude: "7",
            longitude: "21",
            code: "140",
            calling_code: "236",
            continent: "Africa"
        },{
            name: "Chad",
            short_name: "TCD",
            latitude: "15",
            longitude: "19",
            code: "148",
            calling_code: "235",
            continent: "Africa"
        },{
            name: "Chile",
            short_name: "CHL",
            latitude: "-30",
            longitude: "-71",
            code: "152",
            calling_code: "56",
            continent: "South America"
        },{
            name: "China",
            short_name: "CHN",
            latitude: "35",
            longitude: "105",
            code: "156",
            calling_code: "86",
            continent: "Asia"
        },{
            name: "Christmas Island",
            short_name: "CXR",
            latitude: "-10.5",
            longitude: "105.6666667",
            code: "162",
            calling_code: "61",
            continent: "Oceania"
        },{
            name: "Cocos (Keeling) Islands",
            short_name: "CCK",
            latitude: "-12.5",
            longitude: "96.83333333",
            code: "166",
            calling_code: "61",
            continent: "Oceania"
        },{
            name: "Colombia",
            short_name: "COL",
            latitude: "4",
            longitude: "-72",
            code: "170",
            calling_code: "57",
            continent: "South America"
        },{
            name: "Comoros",
            short_name: "COM",
            latitude: "-12.16666666",
            longitude: "44.25",
            code: "174",
            calling_code: "269",
            continent: "Africa"
        },{
            name: "Congo",
            short_name: "COG",
            latitude: "-1",
            longitude: "15",
            code: "178",
            calling_code: "242",
            continent: "Africa"
        },{
            name: "Congo (Democratic Republic of the)",
            short_name: "COD",
            latitude: "0",
            longitude: "25",
            code: "180",
            calling_code: "243",
            continent: "Africa"
        },{
            name: "Cook Islands",
            short_name: "COK",
            latitude: "-21.23333333",
            longitude: "-159.7666667",
            code: "184",
            calling_code: "682",
            continent: "Oceania"
        },{
            name: "Costa Rica",
            short_name: "CRI",
            latitude: "10",
            longitude: "-84",
            code: "188",
            calling_code: "506",
            continent: "South America"
        },{
            name: "Croatia",
            short_name: "HRV",
            latitude: "45.16666666",
            longitude: "15.5",
            code: "191",
            calling_code: "385",
            continent: "Europe"
        },{
            name: "Cuba",
            short_name: "CUB",
            latitude: "21.5",
            longitude: "-80",
            code: "192",
            calling_code: "53",
            continent: "South America"
        },{
            name: "Curaçao",
            short_name: "CUW",
            latitude: "12.116667",
            longitude: "-68.933333",
            code: "531",
            calling_code: "599",
            continent: "South America"
        },{
            name: "Cyprus",
            short_name: "CYP",
            latitude: "35",
            longitude: "33",
            code: "196",
            calling_code: "357",
            continent: "Europe"
        },{
            name: "Czech Republic",
            short_name: "CZE",
            latitude: "49.75",
            longitude: "15.5",
            code: "203",
            calling_code: "420",
            continent: "Europe"
        },{
            name: "Denmark",
            short_name: "DNK",
            latitude: "56",
            longitude: "10",
            code: "208",
            calling_code: "45",
            continent: "Europe"
        },{
            name: "Djibouti",
            short_name: "DJI",
            latitude: "11.5",
            longitude: "43",
            code: "262",
            calling_code: "253",
            continent: "Africa"
        },{
            name: "Dominica",
            short_name: "DMA",
            latitude: "15.41666666",
            longitude: "-61.33333333",
            code: "212",
            calling_code: "1767",
            continent: "South America"
        },{
            name: "Dominican Republic",
            short_name: "DOM",
            latitude: "19",
            longitude: "-70.66666666",
            code: "214",
            calling_code: "1809",
            continent: "South America"
        },{
            name: "Ecuador",
            short_name: "ECU",
            latitude: "-2",
            longitude: "-77.5",
            code: "218",
            calling_code: "593",
            continent: "South America"
        },{
            name: "Egypt",
            short_name: "EGY",
            latitude: "27",
            longitude: "30",
            code: "818",
            calling_code: "20",
            continent: "Africa"
        },{
            name: "El Salvador",
            short_name: "SLV",
            latitude: "13.83333333",
            longitude: "-88.91666666",
            code: "222",
            calling_code: "503",
            continent: "South America"
        },{
            name: "Equatorial Guinea",
            short_name: "GNQ",
            latitude: "2",
            longitude: "10",
            code: "226",
            calling_code: "240",
            continent: "Africa"
        },{
            name: "Eritrea",
            short_name: "ERI",
            latitude: "15",
            longitude: "39",
            code: "232",
            calling_code: "291",
            continent: "Africa"
        },{
            name: "Estonia",
            short_name: "EST",
            latitude: "59",
            longitude: "26",
            code: "233",
            calling_code: "372",
            continent: "Europe"
        },{
            name: "Ethiopia",
            short_name: "ETH",
            latitude: "8",
            longitude: "38",
            code: "231",
            calling_code: "251",
            continent: "Africa"
        },{
            name: "Falkland Islands (Malvinas)",
            short_name: "FLK",
            latitude: "-51.75",
            longitude: "-59",
            code: "238",
            calling_code: "500",
            continent: "South America"
        },{
            name: "Faroe Islands",
            short_name: "FRO",
            latitude: "62",
            longitude: "-7",
            code: "234",
            calling_code: "298",
            continent: "Europe"
        },{
            name: "Fiji",
            short_name: "FJI",
            latitude: "-18",
            longitude: "175",
            code: "242",
            calling_code: "679",
            continent: "Oceania"
        },{
            name: "Finland",
            short_name: "FIN",
            latitude: "64",
            longitude: "26",
            code: "246",
            calling_code: "358",
            continent: "Europe"
        },{
            name: "France",
            short_name: "FRA",
            latitude: "46",
            longitude: "2",
            code: "250",
            calling_code: "33",
            continent: "Europe"
        },{
            name: "French Guiana",
            short_name: "GUF",
            latitude: "4",
            longitude: "-53",
            code: "254",
            calling_code: "594",
            continent: "South America"
        },{
            name: "French Polynesia",
            short_name: "PYF",
            latitude: "-15",
            longitude: "-140",
            code: "258",
            calling_code: "689",
            continent: "Oceania"
        },{
            name: "French Southern Territories",
            short_name: "ATF",
            latitude: "-49.25",
            longitude: "69.167",
            code: "260",
            calling_code: "",
            continent: "Africa"
        },{
            name: "Gabon",
            short_name: "GAB",
            latitude: "-1",
            longitude: "11.75",
            code: "266",
            calling_code: "241",
            continent: "Africa"
        },{
            name: "Gambia",
            short_name: "GMB",
            latitude: "13.46666666",
            longitude: "-16.56666666",
            code: "270",
            calling_code: "220",
            continent: "Africa"
        },{
            name: "Georgia",
            short_name: "GEO",
            latitude: "42",
            longitude: "43.5",
            code: "268",
            calling_code: "995",
            continent: "Asia"
        },{
            name: "Germany",
            short_name: "DEU",
            latitude: "51",
            longitude: "9",
            code: "276",
            calling_code: "49",
            continent: "Europe"
        },{
            name: "Ghana",
            short_name: "GHA",
            latitude: "8",
            longitude: "-2",
            code: "288",
            calling_code: "233",
            continent: "Africa"
        },{
            name: "Gibraltar",
            short_name: "GIB",
            latitude: "36.13333333",
            longitude: "-5.35",
            code: "292",
            calling_code: "350",
            continent: "Europe"
        },{
            name: "Greece",
            short_name: "GRC",
            latitude: "39",
            longitude: "22",
            code: "300",
            calling_code: "30",
            continent: "Europe"
        },{
            name: "Greenland",
            short_name: "GRL",
            latitude: "72",
            longitude: "-40",
            code: "304",
            calling_code: "299",
            continent: "North America"
        },{
            name: "Grenada",
            short_name: "GRD",
            latitude: "12.11666666",
            longitude: "-61.66666666",
            code: "308",
            calling_code: "1473",
            continent: "South America"
        },{
            name: "Guadeloupe",
            short_name: "GLP",
            latitude: "16.25",
            longitude: "-61.583333",
            code: "312",
            calling_code: "590",
            continent: "South America"
        },{
            name: "Guam",
            short_name: "GUM",
            latitude: "13.46666666",
            longitude: "144.7833333",
            code: "316",
            calling_code: "1671",
            continent: "Oceania"
        },{
            name: "Guatemala",
            short_name: "GTM",
            latitude: "15.5",
            longitude: "-90.25",
            code: "320",
            calling_code: "502",
            continent: "South America"
        },{
            name: "Guernsey",
            short_name: "GGY",
            latitude: "49.46666666",
            longitude: "-2.58333333",
            code: "831",
            calling_code: "44",
            continent: "Europe"
        },{
            name: "Guinea",
            short_name: "GIN",
            latitude: "11",
            longitude: "-10",
            code: "324",
            calling_code: "224",
            continent: "Africa"
        },{
            name: "Guinea-Bissau",
            short_name: "GNB",
            latitude: "12",
            longitude: "-15",
            code: "624",
            calling_code: "245",
            continent: "Africa"
        },{
            name: "Guyana",
            short_name: "GUY",
            latitude: "5",
            longitude: "-59",
            code: "328",
            calling_code: "592",
            continent: "South America"
        },{
            name: "Haiti",
            short_name: "HTI",
            latitude: "19",
            longitude: "-72.41666666",
            code: "332",
            calling_code: "509",
            continent: "South America"
        },{
            name: "Heard Island and McDonald Islands",
            short_name: "HMD",
            latitude: "-53.1",
            longitude: "72.51666666",
            code: "334",
            calling_code: ""
        },{
            name: "Holy See",
            short_name: "VAT",
            latitude: "41.9",
            longitude: "12.45",
            code: "336",
            calling_code: "379",
            continent: "Europe"
        },{
            name: "Honduras",
            short_name: "HND",
            latitude: "15",
            longitude: "-86.5",
            code: "340",
            calling_code: "504",
            continent: "South America"
        },{
            name: "Hong Kong",
            short_name: "HKG",
            latitude: "22.25",
            longitude: "114.1666667",
            code: "344",
            calling_code: "852",
            continent: "Asia"
        },{
            name: "Hungary",
            short_name: "HUN",
            latitude: "47",
            longitude: "20",
            code: "348",
            calling_code: "36",
            continent: "Europe"
        },{
            name: "Iceland",
            short_name: "ISL",
            latitude: "65",
            longitude: "-18",
            code: "352",
            calling_code: "354",
            continent: "Europe"
        },{
            name: "India",
            short_name: "IND",
            latitude: "20",
            longitude: "77",
            code: "356",
            calling_code: "91",
            continent: "Asia"
        },{
            name: "Indonesia",
            short_name: "IDN",
            latitude: "-5",
            longitude: "120",
            code: "360",
            calling_code: "62",
            continent: "Asia"
        },{
            name: "Côte d'Ivoire",
            short_name: "CIV",
            latitude: "8",
            longitude: "-5",
            code: "384",
            calling_code: "225",
            continent: "Africa"
        },{
            name: "Iran (Islamic Republic of)",
            short_name: "IRN",
            latitude: "32",
            longitude: "53",
            code: "364",
            calling_code: "98",
            continent: "Asia"
        },{
            name: "Iraq",
            short_name: "IRQ",
            latitude: "33",
            longitude: "44",
            code: "368",
            calling_code: "964",
            continent: "Asia"
        },{
            name: "Ireland",
            short_name: "IRL",
            latitude: "53",
            longitude: "-8",
            code: "372",
            calling_code: "353",
            continent: "Europe"
        },{
            name: "Isle of Man",
            short_name: "IMN",
            latitude: "54.25",
            longitude: "-4.5",
            code: "833",
            calling_code: "44",
            continent: "Europe"
        },{
            name: "Israel",
            short_name: "ISR",
            latitude: "31.5",
            longitude: "34.75",
            code: "376",
            calling_code: "972",
            continent: "Asia"
        },{
            name: "Italy",
            short_name: "ITA",
            latitude: "42.83333333",
            longitude: "12.83333333",
            code: "380",
            calling_code: "39",
            continent: "Europe"
        },{
            name: "Jamaica",
            short_name: "JAM",
            latitude: "18.25",
            longitude: "-77.5",
            code: "388",
            calling_code: "1876",
            continent: "South America"
        },{
            name: "Japan",
            short_name: "JPN",
            latitude: "36",
            longitude: "138",
            code: "392",
            calling_code: "81",
            continent: "Asia"
        },{
            name: "Jersey",
            short_name: "JEY",
            latitude: "49.25",
            longitude: "-2.16666666",
            code: "832",
            calling_code: "44",
            continent: "Europe"
        },{
            name: "Jordan",
            short_name: "JOR",
            latitude: "31",
            longitude: "36",
            code: "400",
            calling_code: "962",
            continent: "Asia"
        },{
            name: "Kazakhstan",
            short_name: "KAZ",
            latitude: "48",
            longitude: "68",
            code: "398",
            calling_code: "76",
            continent: "Asia"
        },{
            name: "Kenya",
            short_name: "KEN",
            latitude: "1",
            longitude: "38",
            code: "404",
            calling_code: "254",
            continent: "Africa"
        },{
            name: "Kiribati",
            short_name: "KIR",
            latitude: "1.41666666",
            longitude: "173",
            code: "296",
            calling_code: "686",
            continent: "Oceania"
        },{
            name: "Kuwait",
            short_name: "KWT",
            latitude: "29.5",
            longitude: "45.75",
            code: "414",
            calling_code: "965",
            continent: "Asia"
        },{
            name: "Kyrgyzstan",
            short_name: "KGZ",
            latitude: "41",
            longitude: "75",
            code: "417",
            calling_code: "996",
            continent: "Asia"
        },{
            name: "Lao People's Democratic Republic",
            short_name: "LAO",
            latitude: "18",
            longitude: "105",
            code: "418",
            calling_code: "856",
            continent: "Asia"
        },{
            name: "Latvia",
            short_name: "LVA",
            latitude: "57",
            longitude: "25",
            code: "428",
            calling_code: "371",
            continent: "Europe"
        },{
            name: "Lebanon",
            short_name: "LBN",
            latitude: "33.83333333",
            longitude: "35.83333333",
            code: "422",
            calling_code: "961",
            continent: "Asia"
        },{
            name: "Lesotho",
            short_name: "LSO",
            latitude: "-29.5",
            longitude: "28.5",
            code: "426",
            calling_code: "266",
            continent: "Africa"
        },{
            name: "Liberia",
            short_name: "LBR",
            latitude: "6.5",
            longitude: "-9.5",
            code: "430",
            calling_code: "231",
            continent: "Africa"
        },{
            name: "Libya",
            short_name: "LBY",
            latitude: "25",
            longitude: "17",
            code: "434",
            calling_code: "218",
            continent: "Africa"
        },{
            name: "Liechtenstein",
            short_name: "LIE",
            latitude: "47.26666666",
            longitude: "9.53333333",
            code: "438",
            calling_code: "423",
            continent: "Europe"
        },{
            name: "Lithuania",
            short_name: "LTU",
            latitude: "56",
            longitude: "24",
            code: "440",
            calling_code: "370",
            continent: "Europe"
        },{
            name: "Luxembourg",
            short_name: "LUX",
            latitude: "49.75",
            longitude: "6.16666666",
            code: "442",
            calling_code: "352",
            continent: "Europe"
        },{
            name: "Macao",
            short_name: "MAC",
            latitude: "22.16666666",
            longitude: "113.55",
            code: "446",
            calling_code: "853",
            continent: "Asia"
        },{
            name: "Macedonia (the former Yugoslav Republic of)",
            short_name: "MKD",
            latitude: "41.83333333",
            longitude: "22",
            code: "807",
            calling_code: "389",
            continent: "Europe"
        },{
            name: "Madagascar",
            short_name: "MDG",
            latitude: "-20",
            longitude: "47",
            code: "450",
            calling_code: "261",
            continent: "Africa"
        },{
            name: "Malawi",
            short_name: "MWI",
            latitude: "-13.5",
            longitude: "34",
            code: "454",
            calling_code: "265",
            continent: "Africa"
        },{
            name: "Malaysia",
            short_name: "MYS",
            latitude: "2.5",
            longitude: "112.5",
            code: "458",
            calling_code: "60",
            continent: "Asia"
        },{
            name: "Maldives",
            short_name: "MDV",
            latitude: "3.25",
            longitude: "73",
            code: "462",
            calling_code: "960",
            continent: "Asia"
        },{
            name: "Mali",
            short_name: "MLI",
            latitude: "17",
            longitude: "-4",
            code: "466",
            calling_code: "223",
            continent: "Africa"
        },{
            name: "Malta",
            short_name: "MLT",
            latitude: "35.83333333",
            longitude: "14.58333333",
            code: "470",
            calling_code: "356",
            continent: "Europe"
        },{
            name: "Marshall Islands",
            short_name: "MHL",
            latitude: "9",
            longitude: "168",
            code: "584",
            calling_code: "692",
            continent: "Oceania"
        },{
            name: "Martinique",
            short_name: "MTQ",
            latitude: "14.666667",
            longitude: "-61",
            code: "474",
            calling_code: "596",
            continent: "South America"
        },{
            name: "Mauritania",
            short_name: "MRT",
            latitude: "20",
            longitude: "-12",
            code: "478",
            calling_code: "222",
            continent: "Africa"
        },{
            name: "Mauritius",
            short_name: "MUS",
            latitude: "-20.28333333",
            longitude: "57.55",
            code: "480",
            calling_code: "230",
            continent: "Africa"
        },{
            name: "Mayotte",
            short_name: "MYT",
            latitude: "-12.83333333",
            longitude: "45.16666666",
            code: "175",
            calling_code: "262",
            continent: "Africa"
        },{
            name: "Mexico",
            short_name: "MEX",
            latitude: "23",
            longitude: "-102",
            code: "484",
            calling_code: "52",
            continent: "South America"
        },{
            name: "Micronesia (Federated States of)",
            short_name: "FSM",
            latitude: "6.91666666",
            longitude: "158.25",
            code: "583",
            calling_code: "691",
            continent: "Oceania"
        },{
            name: "Moldova (Republic of)",
            short_name: "MDA",
            latitude: "47",
            longitude: "29",
            code: "498",
            calling_code: "373",
            continent: "Europe"
        },{
            name: "Monaco",
            short_name: "MCO",
            latitude: "43.73333333",
            longitude: "7.4",
            code: "492",
            calling_code: "377",
            continent: "Europe"
        },{
            name: "Mongolia",
            short_name: "MNG",
            latitude: "46",
            longitude: "105",
            code: "496",
            calling_code: "976",
            continent: "Asia"
        },{
            name: "Montenegro",
            short_name: "MNE",
            latitude: "42.5",
            longitude: "19.3",
            code: "499",
            calling_code: "382",
            continent: "Europe"
        },{
            name: "Montserrat",
            short_name: "MSR",
            latitude: "16.75",
            longitude: "-62.2",
            code: "500",
            calling_code: "1664",
            continent: "South America"
        },{
            name: "Morocco",
            short_name: "MAR",
            latitude: "32",
            longitude: "-5",
            code: "504",
            calling_code: "212",
            continent: "Africa"
        },{
            name: "Mozambique",
            short_name: "MOZ",
            latitude: "-18.25",
            longitude: "35",
            code: "508",
            calling_code: "258",
            continent: "Africa"
        },{
            name: "Myanmar",
            short_name: "MMR",
            latitude: "22",
            longitude: "98",
            code: "104",
            calling_code: "95",
            continent: "Asia"
        },{
            name: "Namibia",
            short_name: "NAM",
            latitude: "-22",
            longitude: "17",
            code: "516",
            calling_code: "264",
            continent: "Africa"
        },{
            name: "Nauru",
            short_name: "NRU",
            latitude: "-0.53333333",
            longitude: "166.9166667",
            code: "520",
            calling_code: "674",
            continent: "Oceania"
        },{
            name: "Nepal",
            short_name: "NPL",
            latitude: "28",
            longitude: "84",
            code: "524",
            calling_code: "977",
            continent: "Asia"
        },{
            name: "Netherlands",
            short_name: "NLD",
            latitude: "52.5",
            longitude: "5.75",
            code: "528",
            calling_code: "31",
            continent: "Europe"
        },{
            name: "New Caledonia",
            short_name: "NCL",
            latitude: "-21.5",
            longitude: "165.5",
            code: "540",
            calling_code: "687",
            continent: "Oceania"
        },{
            name: "New Zealand",
            short_name: "NZL",
            latitude: "-41",
            longitude: "174",
            code: "554",
            calling_code: "64",
            continent: "Oceania"
        },{
            name: "Nicaragua",
            short_name: "NIC",
            latitude: "13",
            longitude: "-85",
            code: "558",
            calling_code: "505",
            continent: "South America"
        },{
            name: "Niger",
            short_name: "NER",
            latitude: "16",
            longitude: "8",
            code: "562",
            calling_code: "227",
            continent: "Africa"
        },{
            name: "Nigeria",
            short_name: "NGA",
            latitude: "10",
            longitude: "8",
            code: "566",
            calling_code: "234",
            continent: "Africa"
        },{
            name: "Niue",
            short_name: "NIU",
            latitude: "-19.03333333",
            longitude: "-169.8666667",
            code: "570",
            calling_code: "683",
            continent: "Oceania"
        },{
            name: "Norfolk Island",
            short_name: "NFK",
            latitude: "-29.03333333",
            longitude: "167.95",
            code: "574",
            calling_code: "672",
            continent: "Oceania"
        },{
            name: "Korea (Democratic People's Republic of)",
            short_name: "PRK",
            latitude: "40",
            longitude: "127",
            code: "408",
            calling_code: "850",
            continent: "Asia"
        },{
            name: "Northern Mariana Islands",
            short_name: "MNP",
            latitude: "15.2",
            longitude: "145.75",
            code: "580",
            calling_code: "1670",
            continent: "Oceania"
        },{
            name: "Norway",
            short_name: "NOR",
            latitude: "62",
            longitude: "10",
            code: "578",
            calling_code: "47",
            continent: "Europe"
        },{
            name: "Oman",
            short_name: "OMN",
            latitude: "21",
            longitude: "57",
            code: "512",
            calling_code: "968",
            continent: "Asia"
        },{
            name: "Pakistan",
            short_name: "PAK",
            latitude: "30",
            longitude: "70",
            code: "586",
            calling_code: "92",
            continent: "Asia"
        },{
            name: "Palau",
            short_name: "PLW",
            latitude: "7.5",
            longitude: "134.5",
            code: "585",
            calling_code: "680",
            continent: "Oceania"
        },{
            name: "Palestine State of",
            short_name: "PSE",
            latitude: "31.9",
            longitude: "35.2",
            code: "275",
            calling_code: "970",
            continent: "Asia"
        },{
            name: "Panama",
            short_name: "PAN",
            latitude: "9",
            longitude: "-80",
            code: "591",
            calling_code: "507",
            continent: "South America"
        },{
            name: "Papua New Guinea",
            short_name: "PNG",
            latitude: "-6",
            longitude: "147",
            code: "598",
            calling_code: "675",
            continent: "Oceania"
        },{
            name: "Paraguay",
            short_name: "PRY",
            latitude: "-23",
            longitude: "-58",
            code: "600",
            calling_code: "595",
            continent: "South America"
        },{
            name: "Peru",
            short_name: "PER",
            latitude: "-10",
            longitude: "-76",
            code: "604",
            calling_code: "51",
            continent: "South America"
        },{
            name: "Philippines",
            short_name: "PHL",
            latitude: "13",
            longitude: "122",
            code: "608",
            calling_code: "63",
            continent: "Asia"
        },{
            name: "Pitcairn",
            short_name: "PCN",
            latitude: "-25.06666666",
            longitude: "-130.1",
            code: "612",
            calling_code: "64",
            continent: "Oceania"
        },{
            name: "Poland",
            short_name: "POL",
            latitude: "52",
            longitude: "20",
            code: "616",
            calling_code: "48",
            continent: "Europe"
        },{
            name: "Portugal",
            short_name: "PRT",
            latitude: "39.5",
            longitude: "-8",
            code: "620",
            calling_code: "351",
            continent: "Europe"
        },{
            name: "Puerto Rico",
            short_name: "PRI",
            latitude: "18.25",
            longitude: "-66.5",
            code: "630",
            calling_code: "1787",
            continent: "South America"
        },{
            name: "Qatar",
            short_name: "QAT",
            latitude: "25.5",
            longitude: "51.25",
            code: "634",
            calling_code: "974",
            continent: "Asia"
        },{
            name: "Republic of Kosovo",
            short_name: "KOS",
            latitude: "42.666667",
            longitude: "21.166667",
            code: nil,
            calling_code: "383",
            continent: "Europe"
        },{
            name: "Réunion",
            short_name: "REU",
            latitude: "-21.15",
            longitude: "55.5",
            code: "638",
            calling_code: "262",
            continent: "Africa"
        },{
            name: "Romania",
            short_name: "ROU",
            latitude: "46",
            longitude: "25",
            code: "642",
            calling_code: "40",
            continent: "Europe"
        },{
            name: "Russian Federation",
            short_name: "RUS",
            latitude: "60",
            longitude: "100",
            code: "643",
            calling_code: "7",
            continent: "Europe"
        },{
            name: "Rwanda",
            short_name: "RWA",
            latitude: "-2",
            longitude: "30",
            code: "646",
            calling_code: "250",
            continent: "Africa"
        },{
            name: "Saint Barthélemy",
            short_name: "BLM",
            latitude: "18.5",
            longitude: "-63.41666666",
            code: "652",
            calling_code: "590",
            continent: "South America"
        },{
            name: "Saint Helena Ascension and Tristan da Cunha",
            short_name: "SHN",
            latitude: "-15.95",
            longitude: "-5.7",
            code: "654",
            calling_code: "290",
            continent: "Africa"
        },{
            name: "Saint Kitts and Nevis",
            short_name: "KNA",
            latitude: "17.33333333",
            longitude: "-62.75",
            code: "659",
            calling_code: "1869",
            continent: "South America"
        },{
            name: "Saint Lucia",
            short_name: "LCA",
            latitude: "13.88333333",
            longitude: "-60.96666666",
            code: "662",
            calling_code: "1758",
            continent: "South America"
        },{
            name: "Saint Martin (French part)",
            short_name: "MAF",
            latitude: "18.08333333",
            longitude: "-63.95",
            code: "663",
            calling_code: "590",
            continent: "South America"
        },{
            name: "Saint Pierre and Miquelon",
            short_name: "SPM",
            latitude: "46.83333333",
            longitude: "-56.33333333",
            code: "666",
            calling_code: "508",
            continent: "North America"
        },{
            name: "Saint Vincent and the Grenadines",
            short_name: "VCT",
            latitude: "13.25",
            longitude: "-61.2",
            code: "670",
            calling_code: "1784",
            continent: "South America"
        },{
            name: "Samoa",
            short_name: "WSM",
            latitude: "-13.58333333",
            longitude: "-172.3333333",
            code: "882",
            calling_code: "685",
            continent: "Oceania"
        },{
            name: "San Marino",
            short_name: "SMR",
            latitude: "43.76666666",
            longitude: "12.41666666",
            code: "674",
            calling_code: "378",
            continent: "Europe"
        },{
            name: "Sao Tome and Principe",
            short_name: "STP",
            latitude: "1",
            longitude: "7",
            code: "678",
            calling_code: "239",
            continent: "Africa"
        },{
            name: "Saudi Arabia",
            short_name: "SAU",
            latitude: "25",
            longitude: "45",
            code: "682",
            calling_code: "966",
            continent: "Asia"
        },{
            name: "Senegal",
            short_name: "SEN",
            latitude: "14",
            longitude: "-14",
            code: "686",
            calling_code: "221",
            continent: "Africa"
        },{
            name: "Serbia",
            short_name: "SRB",
            latitude: "44",
            longitude: "21",
            code: "688",
            calling_code: "381",
            continent: "Europe"
        },{
            name: "Seychelles",
            short_name: "SYC",
            latitude: "-4.58333333",
            longitude: "55.66666666",
            code: "690",
            calling_code: "248",
            continent: "Africa"
        },{
            name: "Sierra Leone",
            short_name: "SLE",
            latitude: "8.5",
            longitude: "-11.5",
            code: "694",
            calling_code: "232",
            continent: "Africa"
        },{
            name: "Singapore",
            short_name: "SGP",
            latitude: "1.36666666",
            longitude: "103.8",
            code: "702",
            calling_code: "65",
            continent: "Asia"
        },{
            name: "Sint Maarten (Dutch part)",
            short_name: "SXM",
            latitude: "18.033333",
            longitude: "-63.05",
            code: "534",
            calling_code: "1721",
            continent: "South America"
        },{
            name: "Slovakia",
            short_name: "SVK",
            latitude: "48.66666666",
            longitude: "19.5",
            code: "703",
            calling_code: "421",
            continent: "Europe"
        },{
            name: "Slovenia",
            short_name: "SVN",
            latitude: "46.11666666",
            longitude: "14.81666666",
            code: "705",
            calling_code: "386",
            continent: "Europe"
        },{
            name: "Solomon Islands",
            short_name: "SLB",
            latitude: "-8",
            longitude: "159",
            code: "90",
            calling_code: "677",
            continent: "Oceania"
        },{
            name: "Somalia",
            short_name: "SOM",
            latitude: "10",
            longitude: "49",
            code: "706",
            calling_code: "252",
            continent: "Africa"
        },{
            name: "South Africa",
            short_name: "ZAF",
            latitude: "-29",
            longitude: "24",
            code: "710",
            calling_code: "27",
            continent: "Africa"
        },{
            name: "South Georgia and the South Sandwich Islands",
            short_name: "SGS",
            latitude: "-54.5",
            longitude: "-37",
            code: "239",
            calling_code: "500",
            continent: "South America"
        },{
            name: "Korea (Republic of)",
            short_name: "KOR",
            latitude: "37",
            longitude: "127.5",
            code: "410",
            calling_code: "82",
            continent: "Asia"
        },{
            name: "South Sudan",
            short_name: "SSD",
            latitude: "7",
            longitude: "30",
            code: "728",
            calling_code: "211",
            continent: "Africa"
        },{
            name: "Spain",
            short_name: "ESP",
            latitude: "40",
            longitude: "-4",
            code: "724",
            calling_code: "34",
            continent: "Europe"
        },{
            name: "Sri Lanka",
            short_name: "LKA",
            latitude: "7",
            longitude: "81",
            code: "144",
            calling_code: "94",
            continent: "Asia"
        },{
            name: "Sudan",
            short_name: "SDN",
            latitude: "15",
            longitude: "30",
            code: "729",
            calling_code: "249",
            continent: "Africa"
        },{
            name: "Suriname",
            short_name: "SUR",
            latitude: "4",
            longitude: "-56",
            code: "740",
            calling_code: "597",
            continent: "South America"
        },{
            name: "Svalbard and Jan Mayen",
            short_name: "SJM",
            latitude: "78",
            longitude: "20",
            code: "744",
            calling_code: "4779",
            continent: "Europe"
        },{
            name: "Swaziland",
            short_name: "SWZ",
            latitude: "-26.5",
            longitude: "31.5",
            code: "748",
            calling_code: "268",
            continent: "Africa"
        },{
            name: "Sweden",
            short_name: "SWE",
            latitude: "62",
            longitude: "15",
            code: "752",
            calling_code: "46",
            continent: "Europe"
        },{
            name: "Switzerland",
            short_name: "CHE",
            latitude: "47",
            longitude: "8",
            code: "756",
            calling_code: "41",
            continent: "Europe"
        },{
            name: "Syrian Arab Republic",
            short_name: "SYR",
            latitude: "35",
            longitude: "38",
            code: "760",
            calling_code: "963",
            continent: "Asia"
        },{
            name: "Taiwan",
            short_name: "TWN",
            latitude: "23.5",
            longitude: "121",
            code: "158",
            calling_code: "886",
            continent: "Asia"
        },{
            name: "Tajikistan",
            short_name: "TJK",
            latitude: "39",
            longitude: "71",
            code: "762",
            calling_code: "992",
            continent: "Asia"
        },{
            name: "Tanzania United Republic of",
            short_name: "TZA",
            latitude: "-6",
            longitude: "35",
            code: "834",
            calling_code: "255",
            continent: "Africa"
        },{
            name: "Thailand",
            short_name: "THA",
            latitude: "15",
            longitude: "100",
            code: "764",
            calling_code: "66",
            continent: "Asia"
        },{
            name: "Timor-Leste",
            short_name: "TLS",
            latitude: "-8.83333333",
            longitude: "125.9166667",
            code: "626",
            calling_code: "670",
            continent: "Asia"
        },{
            name: "Togo",
            short_name: "TGO",
            latitude: "8",
            longitude: "1.16666666",
            code: "768",
            calling_code: "228",
            continent: "Africa"
        },{
            name: "Tokelau",
            short_name: "TKL",
            latitude: "-9",
            longitude: "-172",
            code: "772",
            calling_code: "690",
            continent: "Oceania"
        },{
            name: "Tonga",
            short_name: "TON",
            latitude: "-20",
            longitude: "-175",
            code: "776",
            calling_code: "676",
            continent: "Oceania"
        },{
            name: "Trinidad and Tobago",
            short_name: "TTO",
            latitude: "11",
            longitude: "-61",
            code: "780",
            calling_code: "1868",
            continent: "South America"
        },{
            name: "Tunisia",
            short_name: "TUN",
            latitude: "34",
            longitude: "9",
            code: "788",
            calling_code: "216",
            continent: "Africa"
        },{
            name: "Turkey",
            short_name: "TUR",
            latitude: "39",
            longitude: "35",
            code: "792",
            calling_code: "90",
            continent: "Asia"
        },{
            name: "Turkmenistan",
            short_name: "TKM",
            latitude: "40",
            longitude: "60",
            code: "795",
            calling_code: "993",
            continent: "Asia"
        },{
            name: "Turks and Caicos Islands",
            short_name: "TCA",
            latitude: "21.75",
            longitude: "-71.58333333",
            code: "796",
            calling_code: "1649",
            continent: "South America"
        },{
            name: "Tuvalu",
            short_name: "TUV",
            latitude: "-8",
            longitude: "178",
            code: "798",
            calling_code: "688",
            continent: "Oceania"
        },{
            name: "Uganda",
            short_name: "UGA",
            latitude: "1",
            longitude: "32",
            code: "800",
            calling_code: "256",
            continent: "Africa"
        },{
            name: "Ukraine",
            short_name: "UKR",
            latitude: "49",
            longitude: "32",
            code: "804",
            calling_code: "380",
            continent: "Europe"
        },{
            name: "United Arab Emirates",
            short_name: "ARE",
            latitude: "24",
            longitude: "54",
            code: "784",
            calling_code: "971",
            continent: "Asia"
        },{
            name: "United Kingdom of Great Britain and Northern Ireland",
            short_name: "GBR",
            latitude: "54",
            longitude: "-2",
            code: "826",
            calling_code: "44",
            continent: "Europe"
        },{
            name: "United States of America",
            short_name: "USA",
            latitude: "38",
            longitude: "-97",
            code: "840",
            calling_code: "1",
            continent: "North America"
        },{
            name: "Uruguay",
            short_name: "URY",
            latitude: "-33",
            longitude: "-56",
            code: "858",
            calling_code: "598",
            continent: "South America"
        },{
            name: "Uzbekistan",
            short_name: "UZB",
            latitude: "41",
            longitude: "64",
            code: "860",
            calling_code: "998",
            continent: "Asia"
        },{
            name: "Vanuatu",
            short_name: "VUT",
            latitude: "-16",
            longitude: "167",
            code: "548",
            calling_code: "678",
            continent: "Oceania"
        },{
            name: "Venezuela (Bolivarian Republic of)",
            short_name: "VEN",
            latitude: "8",
            longitude: "-66",
            code: "862",
            calling_code: "58",
            continent: "South America"
        },{
            name: "Viet Nam",
            short_name: "VNM",
            latitude: "16.16666666",
            longitude: "107.8333333",
            code: "704",
            calling_code: "84",
            continent: "Asia"
        },{
            name: "Wallis and Futuna",
            short_name: "WLF",
            latitude: "-13.3",
            longitude: "-176.2",
            code: "876",
            calling_code: "681",
            continent: "Oceania"
        },{
            name: "Western Sahara",
            short_name: "ESH",
            latitude: "24.5",
            longitude: "-13",
            code: "732",
            calling_code: "212",
            continent: "Africa"
        },{
            name: "Yemen",
            short_name: "YEM",
            latitude: "15",
            longitude: "48",
            code: "887",
            calling_code: "967",
            continent: "Asia"
        },{
            name: "Zambia",
            short_name: "ZMB",
            latitude: "-15",
            longitude: "30",
            code: "894",
            calling_code: "260",
            continent: "Africa"
        },{
            name: "Zimbabwe",
            short_name: "ZWE",
            latitude: "-20",
            longitude: "30",
            code: "716",
            calling_code: "263",
            continent: "Africa"
        }]

        countries.each do |country|

            continent = Account::Location.find_by(name: country[:continent], level: 'continent')
            continent = Account::Location.find_by(name: 'Empty') unless continent

            Account::Location.find_or_create_by!(
                name: country[:name],
                short_name: country[:short_name],
                latitude: country[:latitude],
                longitude: country[:longitude],
                code: country[:code],
                calling_code: country[:calling_code],
                level: 'country',
                parent_id: continent.id,
                account: @account
            )

        end
    end
end
