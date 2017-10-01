# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
unless Rails.env.production?
  # create Demo user
  unless User.find_by_name('Demo')
    User.create!(name: 'Demo', email: 'demo@hvboom.ch', password: 'Demo', password_confirmation: 'Demo')
    puts "User 'Demo' created"
  end

  # add 75 new faked entries
  puts 'Start creating fake credentials...'
  75.times do
    begin
      Credential.create! do |c|
        c.title = Faker::Name.unique.name
        c.url = Faker::Internet.url
        c.login = Faker::Internet.safe_email
        c.secured =  Faker::Boolean.boolean(0.2)
        c.password = 'Demo'
        if c.secured
          c.document = Faker::Lorem.word
        else
          c.document = Faker::Internet.password(10, 20)
        end
        c.comment = Faker::Lorem.sentence(3, true) if Faker::Boolean.boolean(0.2)
      end
    rescue ActiveRecord::RecordNotUnique
    end
  end
  puts "#{Credential.count} credentials exists now"
end
