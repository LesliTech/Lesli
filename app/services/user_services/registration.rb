module UserServices

    class Registration

        def self.complete_registration confirmation_token

            user = User.find_by(confirmation_token: confirmation_token)

            if user.confirmed?
                return {
                    successful: true
                }
            end

            # create account
            account = Account.where("users_id = ?", user.id).first_or_create({
                user: user,
                account_plans_id: 0 # trial account by default
            })

            if !account.save
                return {
                    successful: false,
                    errors: account.errors.full_messages.to_sentence
                }
            end

            # perform user confirmation
            user.confirmed_at = Time.now

            if !user.save
                return {
                    successful: false,
                    errors: user.errors.full_messages.to_sentence
                }
            end

            return {
                successful: true
            }

        end

    end

end
