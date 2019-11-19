class CreateAccounts < ActiveRecord::Migration[5.2]
    def change
        create_table :accounts do |t|
            
            # account status
            t.integer   :status

            # company information
            t.string    :company_name
            t.string    :company_name_legal
            t.string    :company_tag_line

            # location
            t.string    :address

            # contact details
            t.string    :website
            t.string    :phone_number_1
            t.string    :phone_number_2
            t.string    :phone_number_3
            t.string    :phone_number_4
            t.string    :public_email

            # social media
            t.string    :github
            t.string    :twitter
            t.string    :youtube
            t.string    :linkedin
            t.string    :facebook

            t.timestamps
        end

    end
end
