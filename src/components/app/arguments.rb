require "option_parser"
require_relative "../imports/module"

@options = {
  is_dev: -1,
  save: {
    has_save: false,
    dir: nil
  },
}

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
  parser.on( "-s DIR", "--save DIR", "Save all new convert an files." ) do |dir|
    @options[:save][:has_save] = true
    @options[:save][:dir] = File.realdirpath( dir, Dir.pwd() )
  end
  parser.on( "-f MODULE", "--funcs MODULE", "Show all functions from a module." ) do |mod|
    if mod
      puts Components::Module::get_module_data(mod)
    else
      puts "Error: No module name for show an all functions."
    end
    exit
  end
end