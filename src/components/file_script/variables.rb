require "basic_object"

require_relative "../../objects/variables/variable"
require_relative "../../constants"

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
            variable.row = row
            variable.index_row = i

            add(variable)
          end
        end
      end

      self.emit_signal({ type: FIND_VAR_DONE })
    end

    def change_variables
      @children.each do |variable|
        case variable.word
        when VARIABLES[:n]
          variable.row.sub!(VARIABLES[:n], PYTHON_WORDS[:n])
        when VARIABLES[:f]
          variable.row.sub!(VARIABLES[:f], PYTHON_WORDS[:f])
        when VARIABLES[:t]
          variable.row.sub!(VARIABLES[:t], PYTHON_WORDS[:t])
        end
      end
    end
  end
end