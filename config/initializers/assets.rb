# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/
Rails.application.config.assets.precompile += %w( landing_layout.css landing_layout.js contact_layout.css )
Rails.application.config.assets.precompile += %w[*.png *.jpg *.jpeg *.gif]
# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
