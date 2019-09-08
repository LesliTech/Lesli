class User < ApplicationRecord

    devise  :database_authenticatable, 
            :registerable, 
            :recoverable, 
            :rememberable, 
            :trackable, 
            :validatable,
            :confirmable
    
    belongs_to :account , foreign_key: 'accounts_id'

end
