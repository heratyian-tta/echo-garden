namespace :locations do
  desc "Import locations from external API"
  task import: :environment do
    LocationImporter.call
    puts "Locations imported successfully"
  end
end
