require_relative "../constants"
require_relative "file_script/blocks"

module Components
  class Manipulation
    def self.d_class(row, name)
      sym = "\n"
      if row.include?( PYTHON_WORDS[:e] )
        sym = PYTHON_WORDS[:e]
      end
  
      row = self.add_brackets( row, name, sym )
      row = self.d_inheritance(row)
      row
    end

    def self.d_def(row, name)
      row = self.add_brackets( row, name, PYTHON_WORDS[:e] )
      self.d_special_def( row, name )
    end

    def self.d_special_def(row, name)
      is_special = name.index( /^__/ ) && name.each_char
        .with_object(Hash.new(0)) {|c, m| m[c]+=1}["_"] == 2
      
      if is_special
        row.sub(name, name + "_" * 2)
      else
        row
      end
    end

    def self.d_parent_def(row, name)
      comma = row.index( /(#{name}){1}( |:)?(:)/ ) ? "" : ","
      row = row.sub( name, "#{name} self#{comma}" )
  
      self.d_def( row, name )
    end

    def self.d_if(block, index, row_add, &callback)
      words = CONTROLS.merge({en: Components::Blocks::BLOCKS_END[:e]})

      index_down = d_index_down(block, index, words)
      row = block.rows[index]
      callback.call(row)
      
      if index == index_down
        callback.call(nil)
        if row_add.gsub("\n", "").strip.empty?
          row = "".ljust(block.index_dim + DIMENSION) + PYTHON_WORDS[:p] + "\n" + row
        end
      end

      return row
    end

    def self.d_end(block, index, row_add, &callback)
      words = CONTROLS.merge(Components::Blocks::BLOCKS)

      row = block.rows[index]
      callback.call(row)

      if index == block.index_block_end
        callback.call(nil)
        if row_add.gsub("\n", "").sub(Components::Blocks::BLOCKS_END[:e], "").strip.empty?
          row = "".ljust(block.index_dim + DIMENSION) + PYTHON_WORDS[:p] + "\n"
        else
          row.sub!(Components::Blocks::BLOCKS_END[:e], "")
        end
      end
      
      return row
    end

    def self.d_other(row, name)
      self.add_brackets( row, name )
    end

    def self.d_index_down(block, index, words)
      for i in index..block.index_block_end
        row = block.rows[i]
        if !words.select{|k, w| row.include?(w)}.empty?
          return i
        end
      end
      return -1
    end

    def self.d_inheritance(row)
      sym = INHERITANCE_SYMBOL
      if row.include?(sym)
        row = row.sub(sym, "")
      end
  
      return row
    end

    def self.add_brackets(row, name, value = "\n", ignore: ignore = false)
      if row.index(/[()]/) and !ignore
        return row
      end

      s_i = row.index(name) + name.length
      row[s_i] = "(#{row[s_i]}"
      row = row.sub(value, ")#{value}")
      return row
    end
  end
end