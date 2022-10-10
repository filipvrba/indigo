require_relative "src/controllers/root"
require_relative "src/controllers/api"

require_relative "src/application/indigo"

require_relative "src/db"
require "sinatra/router"

use Sinatra::Router do
  mount Controllers::Api
  mount Controllers::Root
end

run Indigo::Application
