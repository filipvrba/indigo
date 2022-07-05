require "scene"

require_relative "file_script"

module Scenes
  class FileController < FV::Scene
    def initialize
      super
      @@open_file_script_listener = -> (signal) {add_file_script(signal[:path])}
      @@init_file_scr_done_listener = -> (signal) {init_file_scr_done(signal[:file_script])}
    end

    def ready
      @parent.connect(Scenes::FileScript::OPEN_FILE_SCRIPT, @@open_file_script_listener)
      self.connect(Scenes::FileScript::INIT_FILE_SCR_DONE, @@init_file_scr_done_listener)
    end

    def ready_find()
      # TODO: Change an values from an file scripts.
      # get_scene(true).emit_signal({ type: Scenes::FileScript::CHANGE_FILE_SCRIPT })

    end

    def free
      super.free
      @parent.disconnect(Scenes::FileScript::OPEN_FILE_SCRIPT, @@open_file_script_listener)
      self.disconnect(Scenes::FileScript::INIT_FILE_SCR_DONE, @@init_file_scr_done_listener)
    end

    def add_file_script(path)
      file = Scenes::FileScript.new
      file.path = path

      add(file, @children.length)
    end

    def init_file_scr_done(file_script)
      puts file_script.name

      if file_script.id == 0
        ready_find()
      else
        child = find_children(file_script.id - 1)
        child.functions.functions.update file_script.functions.functions
      end
    end
  end
end
