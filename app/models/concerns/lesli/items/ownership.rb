module Lesli
    module Items
        module Ownership
            extend ActiveSupport::Concern

            # Item records use the same account as their parent resource. For
            # engine resources this is an Engine::Account; Core resources may
            # return Lesli::Account directly.
            def lesli_item_account
                account
            end

            def lesli_item_accessible_by?(user)
                return false if user.blank?

                item_account = lesli_item_account
                core_account = if item_account.respond_to?(:account)
                    item_account.account
                else
                    item_account
                end

                core_account == user.account
            end
        end
    end
end
