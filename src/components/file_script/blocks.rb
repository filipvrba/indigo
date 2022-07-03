require "basic_object"

require_relative "../../objects/blocks/block"

module Components
  class Blocks < FV::BasicObject

    BLOCKS = {
      :d => "def",
      :c => "class",
      :i => "if",
    }
    BLOCKS_END = {
      :e => "end"
    }
    FIND_BLOCKS_DONE = "find_blocks_done"

    def initialize
      super
      @@block_init_done_listener = -> (signal) {init_block_done(signal[:block])}

      @classes = Array.new
      @defs = Array.new
      @ifs = Array.new
    end

    def ready
      self.connect(Objects::Block::BLOCK_INIT_DONE, @@block_init_done_listener)

      check_defs_exist_class()
    end

    def free
      super.free
      self.disconnect(Objects::Block::BLOCK_INIT_DONE, @@block_init_done_listener)
    end

    def find_blocks()
      @parent.data.each_with_index do |row, i|
        Components::Blocks::BLOCKS.each do |_, block_word|
          index_d = row.index(/\b#{block_word}/) 

          if index_d
            block = Objects::Block.new
            block.word = block_word
            block.row = row
            block.index_row = i
            block.index_dim = index_d
            
            add(block)

            block.emit_signal({ type: Objects::Block::BLOCK_INIT, data: Array.new(@parent.data) })
          end
        end
      end

      check_defs_exist_class()
      self.emit_signal({type: FIND_BLOCKS_DONE})
    end

    def init_block_done(block)
      def emit(block)
        @parent.emit_signal({
          type:  Components::Functions::ADD_FUNCTION,
          name:  block.get_name,
          module: block.class.name
        })
      end

      case block.word
      when BLOCKS[:c]
        @classes.append block
        emit(block)
      when BLOCKS[:d]
        @defs.append block
        emit(block)
      when BLOCKS[:i]
        @ifs.append block
      end
    end

    def check_defs_exist_class()
      @defs.each do |d|
        @classes.each do |c|
          if d.index_row < c.index_block_end
            d.parent_class = c
            break
          end
        end
      end
    end
  end
end