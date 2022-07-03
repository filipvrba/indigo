require "scene"

require_relative "../components/file_script/blocks.rb"
require_relative "../components/file_script/variables.rb"
require_relative "../components/file_script/functions.rb"
require_relative "../components/file_script/imports.rb"

module Scenes
  class FileScript < FV::Scene
    attr_accessor :path
    attr_reader :data
    OPEN_FILE_SCRIPT = "open_file_script"

    def self.find_word(row, word)
      row.index( /#{word}[ \n]/ )
    end

    def initialize
      super
      @blocks = Components::Blocks.new
      @variables = Components::Variables.new
      @imports = Components::Imports.new
      @functions = Components::Functions.new
    end

    def ready
      @data = get_data(@path)
      @id = File.basename(@path)

      add(@blocks, "blocks")
      add(@variables, "variables")
      add(@imports, "imports")
      add(@functions, "functions")

      find_all()
    end

    def find_all()
      @blocks.find_blocks()
      @variables.find_variables()
      @imports.find_imports()
      @functions.find_functions()
    end

    def get_data(file)
      data = Array.new
  
      File.open(file) do |d|
        data = d.readlines
      end
      data[data.length - 1] += "\n"  # Add new line to last line
  
      return data
    end
  end
end