require "scene"

require_relative "file_script"
require_relative "../components/file_controller/output"

module Scenes
  class FileController < FV::Scene
    READY_ALL = "ready_all"
    READY_FREE = "ready_free"

    def initialize
      super
      @@open_file_script_listener = -> (signal) {add_file_script(signal[:path])}
      @@init_file_scr_done_listener = -> (signal) {init_file_scr_done(signal[:file_script])}
      @@ready_free_listener = -> (signal) {ready_free()}

      @output = Components::Output.new
    end

    def ready
      @parent.connect(Scenes::FileScript::OPEN_FILE_SCRIPT, @@open_file_script_listener)
      self.connect(Scenes::FileScript::INIT_FILE_SCR_DONE, @@init_file_scr_done_listener)
      @parent.connect(READY_FREE, @@ready_free_listener)

      add(@output, "output")
    end

    def ready_find()
      self.emit_signal({ type: Scenes::FileScript::CHANGE_FILE_SCRIPT })
      ready_all()
    end

    def ready_all
      @output.create_files
      @parent.emit_signal({
        type: READY_ALL,
        path: @output.get_abs_path( find_children(0) )
      })
    end

    def ready_free
      @output.delete_files
      free()
    end

    def free
      @parent.disconnect(Scenes::FileScript::OPEN_FILE_SCRIPT, @@open_file_script_listener)
      self.disconnect(Scenes::FileScript::INIT_FILE_SCR_DONE, @@init_file_scr_done_listener)
      @parent.disconnect(READY_FREE, @@ready_free_listener)
      super
    end

    def add_file_script(path)
      file = Scenes::FileScript.new
      file.path = path

      add(file, get_file_scripts.length)
    end

    def get_file_scripts
      return @children.select{|child| child.id.is_a?(Integer)}
    end

    def init_file_scr_done(file_script)
      if file_script.id == 0
        ready_find()
      else
        child = find_children(file_script.id - 1)
        child.functions.functions.update file_script.functions.functions
      end
    end
  end
end
