namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    User.create!(first_name: 'Brad',
                 last_name: 'Johnson',
                 email: 'example@example.com',
                 role: 'superadmin',
                 password: 'foobar7878',
                 password_confirmation: 'foobar7878')

    30.times do |n|
      first_name  = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = "example-#{n+1}@example.com"
      role = Staffnet2::Application.config.user_roles.sample
      password  = 'foobar7878'
      User.create!(first_name: first_name,
                   last_name: last_name,
                   email: email,
                   role: role,
                   password: password,
                   password_confirmation: password)
    end
  end
end