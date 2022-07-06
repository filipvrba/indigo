require_relative "components/app/arguments"
require_relative "components/app/helper"
require_relative "components/app/data"

require_relative "scenes/file_controller"

require "scene"

root = FV::Scene.new
root.connect(Scenes::FileController::READY_ALL,
  lambda = -> (signal) {
    path = signal[:path]
    
    if @options[:is_dev] != 2
      p_dev( signal[:data_files], @options[:is_dev])
      if @options[:is_dev] != 1
        system("python #{path}")
      end
    end

    root.emit_signal({ type: Scenes::FileController::READY_FREE, has_save: @options[:save] })
})

file_controller = Scenes::FileController.new
root.add(file_controller, "file_controller")
file_controller.add_file_script(get_file())
