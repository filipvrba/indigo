require_relative "components/app/arguments"
require_relative "components/app/helper"
require_relative "components/app/data"

data = get_data(get_file())

p_dev( data, @options[:is_dev])

if @options[:is_dev] != 1
  system("python -c << END '#{data.join}' END")
end