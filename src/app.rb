require_relative "components/app/arguments"
require_relative "components/app/helper"
require_relative "components/app/data"

require_relative "scenes/file_controller"

require "scene"

root = FV::Scene.new

file_controller = Scenes::FileController.new
root.add(file_controller, "file_controller")
file_controller.add_file_script(get_file())

# if @options[:is_dev] != 2
#   p_dev( file.data, @options[:is_dev])
#   if @options[:is_dev] != 1
#     system("python -c << END '#{data.join}' END")
#   end
# end