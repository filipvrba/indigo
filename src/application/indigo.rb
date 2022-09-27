require_relative "via"

module Indigo
  class Application < Sinatra::Application
    LAYOUT = "layout"
    ROOT_PATH = "../../.."

    configure do
      set :public_folder, File.absolute_path("#{ROOT_PATH}/public", __FILE__)
      set :root         , File.absolute_path("#{ROOT_PATH}", __FILE__)
    end

    def initialize
      super

      @via = Via::Application.new
      @db  = JsonParser.new File.absolute_path("#{ROOT_PATH}/share/db.json", __FILE__)
    end

    def ren symbol, &callback
      erb @via.render LAYOUT do
        erb @via.render symbol do
          callback.call
        end
      end
    end
  end
end