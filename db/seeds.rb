require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Example:
#

5.times do
  User.create(
    provider: "github",
    uid: "#{Faker::Number.number(6)}",
    email: "#{Faker::Internet.email}",
    username: "#{Faker::Name.name}",
    avatar_url: "https://avatars3.githubusercontent.com/u/10716409?v=4&s=400"
  )
end

10.times do
  Meetup.create(
    name: "#{Faker::Space.galaxy} Meetup",
    description: "#{Faker::Lovecraft.sentence}",
    location: "#{Faker::Address.street_address}",
    creator: "#{Faker::Number.between(1, 5)}"
  )
end
