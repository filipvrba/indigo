require "basic_object"

require_relative "../../objects/variables/variable"
require_relative "../../constants"
require_relative "../manipulation"

module Components
  class Variables < FV::BasicObject
    VARIABLES = {
      :n => "nil",
      :f => "false",
      :t => "true"
    }

    FIND_VAR_DONE = "find_variables_done"

    def self.get_var_index(row, var)
      return row.include?(var) &&
      !row.index(/#.*?#{var}.*/) &&
      !row.index(/['"].*?#{var}.*?['"]/) || # /['"].*?\b#{name}\b.*?['"]/
      row.index(/{.*#{var}.*}/)
    end

    def find_variables
      @parent.data.each_with_index do |row, i|
        VARIABLES.each do |_, var_word|
          index_d = Components::Variables::get_var_index(row, var_word)

          if index_d
            variable = Objects::Variable.new
            variable.word = var_word
            variable.row = String.new(row)
            variable.index_row = i

            add(variable)
          end
        end
      end

      self.emit_signal({ type: FIND_VAR_DONE })
    end

    def change_variables
      @children.each do |variable|
        change_row = -> (symbol) {
          @parent.data[variable.index_row].sub(VARIABLES[symbol], PYTHON_WORDS[symbol])
        }

        case variable.word
        when VARIABLES[:n]
          variable.row = change_row.(:n)
        when VARIABLES[:f]
          variable.row = change_row.(:f)
        when VARIABLES[:t]
          variable.row = change_row.(:t)
        end

        owerwrite_variable(variable)
      end
    end

    def owerwrite_variable(variable)
      @parent.data[variable.index_row] = variable.row
    end
  end
end