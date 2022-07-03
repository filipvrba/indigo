require "json"
require_relative "../../project"

module Components
  class Module
    FUNCS = "lib/funcs.py"
    MODULES = {
      b: "builtins"
    }
    VALIED = {
      b: "builtin_function_or_method",
      f: "function"
    }

    def self.get_module_data(name)
      func_path = get_abspath(FUNCS)
      
      value = %x(python #{func_path} #{name})
      return value
    end
  
    def self.get_funcs(name)
      json = self.get_module_data(name)
      json_obj = JSON.parse(json)
      
      error = json_obj[name][0]["error"]
      if error
        return nil
      end

      json_func_obj = json_obj["#{name}"].select do |f|
        type_name = f["type"]["name"]
        !Module::VALIED.select{ |k, v| v == type_name }.empty?
      end

      functions = Hash.new
      json_func_obj.each do |v|
        n = v["name"]
        functions[n] = name
      end

      return functions
    end
  end
end