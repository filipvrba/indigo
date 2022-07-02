require "option_parser"

def get_file
  file = OptionParser.last_arg()

  unless file
    exit()
  else
    if !File.exist?(file)
      puts "A #{file} doest existing, from this a \"#{Dir.pwd()}\" location."
      return exit()
    else
      return file
    end
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
