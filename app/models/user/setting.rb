class User::Setting < ApplicationRecord
    validates :name, presence: true, on: :create
    validates :value, presence: true, on: :create

    after_update :update_associated_record

    def update_associated_record
        if saved_change_to_value

            if defined? CloudOne

                LC::Debug.msg self

                data = {
                    locale: self.value,
                }

                user = User.find_by_id(self.users_id)
                
                if self.name == 'locale'
                    CloudOne::Firebase::User.update_data(user, data)
                end

            end
        end
    end
end
