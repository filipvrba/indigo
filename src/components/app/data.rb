require "option_parser"

def get_file
  file = OptionParser.last_arg()

  if !File.exist?(file)
    puts "A #{file} doest existing, from this a \"#{Dir.pwd()}\" location."
    return exit()
  end

  unless file
    exit()
  else
    return file
  end
end

def get_data file
  data = Array.new

  File.open(file) do |d|
    data = d.readlines
  end
  data[data.length - 1] += "\n"  # Add new line to last line

  return data
end
