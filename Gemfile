source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.5"

gem "rails", "~> 7.0.4", ">= 7.0.4.2"
gem "sprockets-rails"
gem "pg"
gem "sassc-rails"
gem "puma"
gem "devise"
gem "friendly_id"
gem "activeadmin"
gem "jbuilder"
gem "bootsnap", require: false
gem "carrierwave", ">= 3.0.0.beta", "< 4.0"
gem "kaminari"
gem "paper_trail"
gem "wicked_pdf"
gem "wkhtmltopdf-binary"
gem "rack-block"
gem "rack-contrib"
gem "httparty"

group :development, :test do
  gem "rainbow"
  gem "rails_live_reload"
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "web-console"
end

# group :test do
#   gem "capybara"
#   gem "selenium-webdriver"
#   gem "webdrivers"
# end
