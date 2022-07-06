require "option_parser"

@options = { is_dev: -1, save: false }

OptionParser.parse do |parser|
  parser.banner( "Usage: fv [options] [program file]\n\nOptions:" )
  parser.on( "-h", "--help", "Show help" ) do
      puts parser
      exit
  end
  parser.on( "-v", "--version", "Show version" ) do
    puts "Version is 1.0.0"
    exit
  end
  parser.on( "-d ID", "--dev ID", "Enable an developing state." ) do |id|
    is_int = id.to_i.to_s == id
    if is_int
      @options[:is_dev] = id.to_i
    else
      @options[:is_dev] = 0
    end
  end
  parser.on( "-s", "--save", "Save all new convert an files." ) do
    @options[:save] = true
  end
end