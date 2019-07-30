module UserServices

    class Registration

        def self.complete_registration confirmation_token

            user = User.find_by(confirmation_token: confirmation_token)

            if user.confirmed?
                return redirect_to login_path, notice: "User confirmed";
            end

            # create account
            account = Account.where("users_id = ?", user.id).first_or_create({
                user: user,
                account_plans_id: 1
            })
            
            if !account.save
                return {
                    successful: false,
                    errors: errors.full_messages.to_sentence
                }
            end

            # perform user confirmation
            user.confirmed_at = Time.now

            if !user.save
                return {
                    successful: false,
                    errors: errors.full_messages.to_sentence
                }
            end

            return {
                successful: true
            }

        end

    end

end
