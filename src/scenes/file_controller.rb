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
      @@ready_free_listener = -> (signal) {
        has_remove = copy_files(signal[:has_save], signal[:dir])
        ready_free(has_remove)
      }

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
        path: @output.get_relative_path( find_children(0) ),
        data_files: get_data_files
      })
    end

    def copy_files(has_save, dir)
      if has_save
        return @output.copy_files(dir)
      else
        return true
      end
    end

    def ready_free(has_remove)
      if has_remove
        @output.delete_files
      end
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

    def get_data_files
      data_files = Hash.new
      get_file_scripts.each do |file_script|
        data_files[file_script.name] = file_script.data
      end
      return data_files
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
