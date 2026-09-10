# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
sticker_names = %w[ok omg sad idc sorry ded love this]

sticker_names.each do |name|
  sticker = Sticker.find_or_initialize_by(name: name)
  sticker.save!

  unless sticker.sticker_image.attached?
    path = Rails.root.join("app/assets/images/stickers/#{name}.png")

    sticker.sticker_image.attach(
      io: File.open(path),
      filename: "#{name}.png",
      content_type: "image/png"
    )
  end
end

puts "The database has been seeded!"
