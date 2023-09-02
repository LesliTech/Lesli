module Lesli
    class User < ApplicationLesliRecord

        # users belongs to an account only... and must have a role
        belongs_to :account, optional: true
    end
end
