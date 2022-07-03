require "scene"

require_relative "file_script"

module Scenes
  class FileController < FV::Scene
    def initialize
      super
      @@open_file_script_listener = -> (signal) {add_file_script(signal[:path])}
    end

    def ready
      @parent.connect(Scenes::FileScript::OPEN_FILE_SCRIPT, @@open_file_script_listener)
    end

    def free
      super.free
      @parent.disconnect(Scenes::FileScript::OPEN_FILE_SCRIPT, @@open_file_script_listener)
    end

    def add_file_script(path)
      file = Scenes::FileScript.new
      file.path = path

      add(file)
    end
  end
end