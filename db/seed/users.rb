=begin
=end
user = User.new
user.email = 'user@lesli.dev'
user.password = 'lesli$2019'
user.password_confirmation = 'lesli$2019'
user.save!

user = User.new
user.email = 'admin@lesli.dev'
user.password = 'lesli$2019'
user.password_confirmation = 'lesli$2019'
user.save!