require "basic_object"

require_relative "../../constants"
require_relative "../../objects/imports/import"
require_relative "../imports/module"
require_relative "../../scenes/file_script"

module Components
  class Imports < FV::BasicObject
    IMPORTS = {
      :i => "import"
    }

    FIND_IMP_DONE = "find_imports_done"

    def initialize
      super
      @@import_init_done_listener = -> (signal) {init_import_done(signal[:import])}
    end

    def ready
      self.connect(Objects::Import::IMPORT_INIT_DONE, @@import_init_done_listener)
    end

    def free
      self.disconnect(Objects::Import::IMPORT_INIT_DONE, @@import_init_done_listener)
      super
    end

    def default_modules
      add_import(IMPORTS[:i], "import #{Components::Module::MODULES[:b]}", -1)
    end

    def add_import(word, row, index_row)
      import = Objects::Import.new
      import.word = word
      import.row = String.new(row)
      import.index_row = index_row

      add(import)
      import.emit_signal({ type: Objects::Import::IMPORT_INIT })
    end

    def find_imports
      default_modules()

      @parent.data.each_with_index do |row, i|
        imp_word = IMPORTS[:i]
        index_d = Components::Variables::get_var_index(row, imp_word)

        if index_d
          add_import(imp_word, row, i)
        end
      end

      self.emit_signal({ type: FIND_IMP_DONE })
    end

    def init_import_done(import)
      funcs_hash = Components::Module::get_funcs(import.name_module)
      if funcs_hash
        funcs_hash.each do |key, value|
          @parent.emit_signal({
            type:  Components::Functions::ADD_FUNCTION,
            name:  import.index_row == -1 ? key : "#{value}.#{key}",
            module: value
          })
        end
      else
        module_abs_path = "#{Dir.pwd()}/#{import.name_module}.#{INDIGO_FILE_TYPE}"
        get_scene(true).emit_signal({
          type: Scenes::FileScript::OPEN_FILE_SCRIPT,
          path: module_abs_path
        })
      end
    end

    def change_imports()
      @children.each do |import|
        if import.index_row > -1
          if !import.path.empty?
            import.row = "from #{import.path} import #{import.name}\n"
            overwrite_import(import)
          end
        end
      end
    end

    def overwrite_import(import)
      if import.index_row > -1
        @parent.data[import.index_row] = import.row
      end
    end
  end
end