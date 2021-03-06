require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  protect_from_dos_attacks true
  secret "8135654bd7d629861ff64097f93d3134578f64d89d55c8245af550976266f0be"

  url_format "/media/:job/:name"
  url_host 'http://localhost:3000'

  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
