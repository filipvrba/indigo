require "basic_object"

require_relative "../../objects/functions/function"
require_relative "../manipulation"

module Components
  class Functions < FV::BasicObject
    attr_reader :functions
    FIND_FUNC_DONE = "find_functions_done"
    ADD_FUNCTION = "add_function"
    DEFAULT_FUNCTIONS = {
      m: "main",
      p: "print",
      l: "len",
    }

    def initialize
      super
      @@add_function_listener = -> (signal) {add_function(signal[:name], signal[:module])}
      @functions = Hash.new
    end

    def ready
      @parent.connect(ADD_FUNCTION, @@add_function_listener)
    end

    def free
      @parent.disconnect(ADD_FUNCTION, @@add_function_listener)
      super
    end
    
    def default_functions
      Components::Functions::DEFAULT_FUNCTIONS.each do |key, value|
        add_function(value, "DEFAULT_FUNCTIONS")
      end
    end

    def find_functions
      filtering_words = Components::Blocks::BLOCKS.merge
      filtering_words[:im] = Components::Imports::IMPORTS[:i]

      @parent.data.each_with_index do |row, i|
        @functions.each do |_, func_word|
          filter = row.index(/\b#{func_word}\b/) &&
            filtering_words.select { |k, v|
              Components::Variables::get_var_index(row, v) }.empty? &&
            Components::Variables::get_var_index(row, func_word)

          if filter
            function = Objects::Function.new
            function.word = func_word
            function.row = String.new(row)
            function.index_row = i

            add(function)
          end
        end
      end

      default_functions()
      self.emit_signal({ type: FIND_FUNC_DONE })
    end

    def change_functions
      @children.each do |function|
        function.row = Manipulation::d_other(@parent.data[function.index_row] , function.word)
        overwrite_function(function)
      end
    end

    def overwrite_function(function)
      @parent.data[function.index_row] = function.row
    end

    def add_function(name, name_module)
      @functions["#{name_module}.#{name}"] = name
    end
  end
end