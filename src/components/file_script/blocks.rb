require "basic_object"

require_relative "../../objects/blocks/block"
require_relative "../../objects/blocks/block"
require_relative "../manipulation"
require_relative "../../constants"

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
      self.disconnect(Objects::Block::BLOCK_INIT_DONE, @@block_init_done_listener)
      super
    end

    def find_blocks()
      @parent.data.each_with_index do |row, i|
        Components::Blocks::BLOCKS.each do |_, block_word|
          index_d = row.index(/\b#{block_word}/) 

          if index_d
            block = Objects::Block.new
            block.word = block_word
            block.row = String.new(row)
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

    def change_blocks()
      change_classes()
      change_defs()
      change_ifs()
      change_ends()
    end

    def owerwrite_blocks()
      @children.each do |block|
        for i in block.index_row..block.index_block_end
          @parent.data[i] = block.rows[i]
        end
      end
    end

    private
    def change_classes()
      @classes.each do |block|
        row = block.rows[block.index_row]
        block.rows[block.index_row] = Manipulation::d_class(row, block.get_name)
      end
    end

    def change_defs()
      @defs.each do |block|
        row = block.rows[block.index_row]

        if block.parent_class
          block.rows[block.index_row] = Manipulation::d_parent_def(row, block.get_name)
        else
          block.rows[block.index_row] = Manipulation::d_def(row, block.get_name)
        end
      end
    end

    def change_ifs()
      @ifs.each do |block|
        row_add = ""

        for i in (block.index_row + 1)..block.index_block_end
          block.rows[i] = Manipulation::d_if(block, i, row_add) do |row|
            if row
              row_add += row
            else
              row_add = ""
            end
          end
        end
      end
    end

    def change_ends()
      @children.each do |block|
        row_add = ""

        for i in (block.index_row + 1)..block.index_block_end
          block.rows[i] = Manipulation::d_end(block, i, row_add) do |row|
            if row
              row_add += row
            else
              row_add = ""
            end
          end
        end
      end
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
          if d.index_row < c.index_block_end &&
             c.index_dim + DIMENSION == d.index_dim 

            d.parent_class = c
            break
          end
        end
      end
    end
  end
end