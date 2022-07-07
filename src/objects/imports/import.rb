require "basic_object"

module Objects
  class Import < FV::BasicObject
    attr_accessor :word, :row, :index_row
    attr_reader :name_module, :path, :name, :rename
    IMPORT_INIT = "init_import"
    IMPORT_INIT_DONE = "init_import_done"
    
    def initialize
      super
      @@init_import_listener = -> (signal) {init_import()}

      @name_module = nil
      @path = ""
      @name = ""
      @rename = nil
    end

    def ready
      self.connect(IMPORT_INIT, @@init_import_listener)
    end

    def free
      self.disconnect(IMPORT_INIT, @@init_import_listener)
      super
    end

    def init_import
      is_local = @row.split[1].index(/^([.])/)
      
      if is_local
        is_same = @row.index(/ (.) /)
        if is_same
          set_module(3)
        else
          set_module(1)
        end
      else
        @name_module = @row.split[1]
        @path = get_path()
        @name = @name_module.split("/").last

        if @row.split.include?(Components::Imports::IMPORTS[:as])
          @rename = @row.split.last
        end
      end

      @parent.emit_signal({ type: IMPORT_INIT_DONE, import: self })
    end

    private
    def get_path()
      arr = @name_module.split("/")
      arr.take(arr.length - 1).join(".")
    end

    def get_name(index)
      @row.split[index].sub(".", "")
    end

    def set_module(index)
      @name_module = get_name(index)
    end
  end
end