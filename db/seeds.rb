# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
unless Rails.env.production?
  # create Demo users
  3.times do |n|
    user = "Demo#{n+1}"
    unless User.find_by_name(user)
      User.create!(name: user, email: "#{user}@hvboom.ch", password: 'Demo', password_confirmation: 'Demo')
      puts "User '#{user}' created"
    end
  end

  # create shared access group
  puts 'Creating shared access groups...'
  access_group = AccessGroup.find_or_create_by!(name: 'Shared')

  # allow access to shared access group
  user = User.find_by_name('Demo1')
  user.access_groups << access_group unless user.access_groups.include?(access_group)
  user.save
  puts "#{user.name} added to 'Shared' access group"

  user = User.find_by_name('Demo2')
  user.access_groups << access_group unless user.access_groups.include?(access_group)
  user.default_access_group = access_group
  user.save
  puts "#{user.name} added to 'Shared' access group having it as default group too"

  # add 75 new faked entries
  puts 'Start creating fake credentials...'
  count = AccessGroup.count
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
        c.access_group = AccessGroup.find(AccessGroup.ids.shuffle.first)
      end
    rescue ActiveRecord::RecordNotUnique
    end
  end
  puts "#{Credential.count} credentials exists now"
end
