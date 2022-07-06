require "scene"

require_relative "../components/file_script/blocks.rb"
require_relative "../components/file_script/variables.rb"
require_relative "../components/file_script/functions.rb"
require_relative "../components/file_script/imports.rb"
require_relative "../constants"

module Scenes
  class FileScript < FV::Scene
    attr_accessor :path
    attr_reader :data, :name, :functions

    OPEN_FILE_SCRIPT = "open_file_script"
    INIT_FILE_SCR_DONE = "initialize_file_script_done"
    CHANGE_FILE_SCRIPT = "change_file_script"

    def self.find_word(row, word)
      row.index( /#{word}[ \n]/ )
    end

    def initialize
      super
      @@change_file_script_listener = -> (signal) {change_all()}

      @blocks = Components::Blocks.new
      @variables = Components::Variables.new
      @imports = Components::Imports.new
      @functions = Components::Functions.new
    end

    def ready
      @data = get_data(@path)
      unless @data
        puts "#{self} could not initialize!"
        return
      end

      @parent.connect(CHANGE_FILE_SCRIPT, @@change_file_script_listener)
      @name = File.basename(@path)

      add(@blocks, "blocks")
      add(@variables, "variables")
      add(@imports, "imports")
      add(@functions, "functions")

      find_all()
      @parent.emit_signal({ type: INIT_FILE_SCR_DONE, file_script: self })
    end

    def free
      @parent.disconnect(CHANGE_FILE_SCRIPT, @@change_file_script_listener)
      super
    end

    def find_all()
      @blocks.find_blocks()
      @variables.find_variables()
      @imports.find_imports()
      @functions.find_functions()
    end

    def change_all()
      @blocks.change_blocks()
      @blocks.owerwrite_blocks()

      @imports.change_imports()
      @functions.change_functions()
      @variables.change_variables()
    end

    def get_data(file)
      data = Array.new
  
      unless File.exist?(file)
        puts "Warning: This a file '#{file}' no exist."
        return nil
      end

      File.open(file) do |d|
        data = d.readlines
      end
      data[data.length - 1] += "\n"  # Add new line to last line
  
      return data
    end
  end
end