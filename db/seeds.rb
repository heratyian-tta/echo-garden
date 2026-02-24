# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear out old sample users and gardens if needed
# db/seeds.rb

# Clear old data if needed
# Clear out old sample data
GardenPlot.destroy_all
Garden.destroy_all
User.destroy_all

# Sample Alice in Wonderland–themed users
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
  { first_name: "Dormouse", last_name: "Sleepy", email: "dormouse@example.com" }
]

users_created = characters.map do |char|
  location = Location.order("RANDOM()").first
  User.create!(
    first_name: char[:first_name],
    last_name: char[:last_name],
    email: char[:email],
    password: "appdev",
    password_confirmation: "appdev",
    location: location
  )
end

gardens_created = []
plots_created = []

# Create 1–2 gardens per user, varying the size
users_created.each do |user|
  rand(1..2).times do |i|
    rows = [3, 4, 5, 6, 7].sample   # random number of rows
    columns = [3, 4, 5, 6, 7].sample # random number of columns
    garden = user.gardens.create!(
      name: "#{user.first_name}'s Garden #{i + 1}",
      rows: rows,
      columns: columns
    )
    gardens_created << garden
    plots_created += garden.garden_plots.to_a
  end
end


puts "Seeding complete!"
puts "Users created: #{users_created.count}"
puts "Gardens created: #{gardens_created.count}"
puts "Garden plots created: #{plots_created.count}"
