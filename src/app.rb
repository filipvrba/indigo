require_relative "components/app/arguments"
require_relative "components/app/helper"
require_relative "components/app/data"

require "scene"

data = get_data(get_file())

root = FV::Scene.new

p_dev( data, @options[:is_dev])
if @options[:is_dev] != 1
  system("python -c << END '#{data.join}' END")
end