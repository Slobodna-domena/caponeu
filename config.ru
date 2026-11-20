require_relative "config/environment"
use Rack::Deflect, :log => File.open("log/deflect.log", "a"), :request_threshold => 10, :interval => 5, :block_duration => 21600

use Rack::Block do
  ip_pattern "193.112.107.84" do halt 404 end
end

run Rails.application
#Rails.application.load_server
