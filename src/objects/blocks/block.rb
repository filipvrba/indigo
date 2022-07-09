require "basic_object"

module Objects
  class Block < FV::BasicObject
    attr_accessor :word, :row, :index_row, :index_dim, :parent_class
    attr_reader :index_block_end, :rows
    BLOCK_INIT = "init_block"
    BLOCK_INIT_DONE = "init_block_done"

    def initialize
      super
      @@init_block_listener = -> (signal) {init_block(signal[:data])}
      @rows = Array.new
      @index_block_end = -1
    end

    def ready
      self.connect(BLOCK_INIT, @@init_block_listener)
    end

    def free
      self.disconnect(BLOCK_INIT, @@init_block_listener)
      super
    end

    def init_block(data)
      @index_block_end = find_block_end data.drop(@index_row)

      unless @index_block_end
        puts "Warning - Not find index #{@index_dim} for a block end.\n" +
          "This #{self.to_s} of #{@index_row} index."
        exit
      else
        data.each_with_index do |row, i|
          if i < @index_row
            data[i] = ""
          elsif i > @index_block_end
            data[i] = ""
          end
        end
  
        @rows = data
        @parent.emit_signal({type: Objects::Block::BLOCK_INIT_DONE, block: self })
      end
    end

    def find_block_end(data)
      data.each_with_index do |row, i|
        index_end_dim = Scenes::FileScript::find_word(row, Components::Blocks::BLOCKS_END[:e])
        if index_end_dim == @index_dim
          return i + @index_row
        end
      end

      return nil
    end

    def get_name
      s = @row.split(' ')
      return s.length > 1 ? s[1].sub(":", "").sub( /([(][^)]*[)])/, "" ): nil
    end
  end
end