require "basic_object"

require_relative "../../objects/functions/function"

module Components
  class Functions < FV::BasicObject
    FIND_FUNC_DONE = "find_functions_done"
    ADD_FUNCTION = "add_function"

    def initialize
      super
      @@add_function_listener = -> (signal) {add_function(signal[:name], signal[:module])}
      @functions = Hash.new
    end

    def ready
      @parent.connect(ADD_FUNCTION, @@add_function_listener)
    end

    def free
      super.free
      @parent.disconnect(ADD_FUNCTION, @@add_function_listener)
    end
    
    def find_functions
      puts @functions
      @parent.data.each_with_index do |row, i|
        @functions.each do |_, func_word|
          filter = row.index(/\b#{func_word}\b/) &&
            Components::Blocks::BLOCKS.select { |k, v| row.include?( v ) }.empty?

          if filter
            function = Objects::Function.new
            function.word = func_word
            function.row = row
            function.index_row = i

            add(function)

            p row
            break
          end
        end
      end

      self.emit_signal({ type: FIND_FUNC_DONE })
    end

    def add_function(name, name_module)
      @functions["#{name_module}.#{name}"] = name
    end
  end
end