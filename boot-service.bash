# ./config/boot-service.bash
bundle binstubs bundler --force
RAILS_ENV=production BUNDLE_GEMFILE=/app/current/Gemfile bundle exec unicorn -c /app/current/config/unicorn.rb -E deployment -D

