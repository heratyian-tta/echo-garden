# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear out old sample users and gardens if needed
Garden.destroy_all
User.destroy_all

# Hard-coded Alice in Wonderland characters
characters = [
  { first_name: "Alice", last_name: "Liddell", email: "alice@example.com" },
  { first_name: "Mad Hatter", last_name: "Hatson", email: "mad.hatter@example.com" },
  { first_name: "Cheshire", last_name: "Cat", email: "cheshire.cat@example.com" },
  { first_name: "White", last_name: "Rabbit", email: "white.rabbit@example.com" },
  { first_name: "Queen", last_name: "Hearts", email: "queen.hearts@example.com" },
  { first_name: "March", last_name: "Hare", email: "march.hare@example.com" },
  { first_name: "Tweedle", last_name: "Dee", email: "tweedle.dee@example.com" },
  { first_name: "Tweedle", last_name: "Dum", email: "tweedle.dum@example.com" },
  { first_name: "Caterpillar", last_name: "Absolem", email: "caterpillar@example.com" },
  { first_name: "Dormouse", last_name: "Sleepy", email: "dormouse@example.com" },
  { first_name: "King", last_name: "Hearts", email: "king.hearts@example.com" }
]

characters.each do |char|
  location = Location.order("RANDOM()").first

  user = User.create!(
    first_name: char[:first_name],
    last_name: char[:last_name],
    email: char[:email],
    password: "password123",
    password_confirmation: "password123",
    location: location
  )

  # Create two gardens per user
  2.times do |i|
    user.gardens.create!(
      name: "#{char[:first_name]}'s Garden #{i + 1}",
      rows: rand(5..10),       # random rows between 5 and 10
      columns: rand(5..10)     # random columns between 5 and 10
    )
  end
end
puts "Created #{User.count} sample users!"
