require_relative "via"

module Indigo
  class Application < Sinatra::Application
    LAYOUT = "layout"

    def initialize
      super

      @via = Via::Application.new
      @db  = JsonParser.new File.absolute_path("../../../share/db.json", __FILE__)
    end

    def ren symbol
      erb @via.render_via LAYOUT do
        erb @via.render_via symbol
      end
    end
  end
end