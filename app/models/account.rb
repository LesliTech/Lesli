class Account < ApplicationRecord

    has_many :users, foreign_key: 'accounts_id'

    has_one :bell, class_name: "Bell", foreign_key: "id"
    #has_one :lock,   class_name: "Lock",   foreign_key: "id"

    has_one :kb,     class_name: "CloudKb::Account",     foreign_key: "id"
    has_one :lock,   class_name: "CloudLock::Account",   foreign_key: "id"
    has_one :team,   class_name: "CloudTeam::Account",   foreign_key: "id"
    has_one :help,   class_name: "CloudHelp::Account",   foreign_key: "id"
    has_one :books,  class_name: "CloudBooks::Account",  foreign_key: "id"
    has_one :panel,  class_name: "CloudPanel::Account",  foreign_key: "id"
    has_one :driver, class_name: "CloudDriver::Account", foreign_key: "id"

end
