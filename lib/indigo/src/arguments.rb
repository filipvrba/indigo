require_relative "version"

@options = {
  g_controller: nil,
}

OptionParser.parse do |parser|
  parser.banner( "Usage: indigo [options]\n\nOptions:" )
  parser.on( "-h", "--help", "Show help" ) do
      puts parser
      exit
  end
  parser.on( "-v", "--version", "Show version" ) do
    puts VERSIONS.last
    exit
  end
  parser.on( "-g CONT", "--generate CONT", "Generate controller to indigo appliacation." ) do |controller|
    @options[:g_controller] = controller
  end
end