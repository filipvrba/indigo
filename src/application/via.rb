require "sinatra"
require File.absolute_path("../../../lib/index.rb", __FILE__)

module Via
  class Application
    VIEWS_PATH = "../../../views"

    def initialize
      @root = FV::Scene.new
      @in_out = Components::InOut.new
      
      @root.add(@in_out, "IO")
    end

    def render_via(symbol)
      path = File.absolute_path("#{VIEWS_PATH}/#{symbol.to_s}.via", __FILE__)
      result = nil

      if File.exist? path
        file = Scenes::FileScript.new
        file.path = path
        file.name = File.basename path
        file.data = @in_out.open_file_with_data(path)

        @root.add(file, symbol)

        result = file.data.join
        file.free
      end

      return result
    end
  end
end