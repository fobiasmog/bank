# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

2000.times do
  user = User.create!(name: FFaker::Name.name, email: FFaker::Internet.email, avatar_url: FFaker::Avatar.image)
  Account.create!(user: user, balance: FFaker::Number.decimal, iban: FFaker::Bank.iban)
end
