=begin
=end
user = User.new
user.email = 'user@lesli.dev'
user.password = 'lesli2020'
user.password_confirmation = 'lesli2020'
user.save!

user = User.new
user.email = 'admin@lesli.dev'
user.password = 'lesli2020'
user.password_confirmation = 'lesli2020'
user.save!