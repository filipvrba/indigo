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

    def self.d_if(rows, index)
      r_u = rows[index]
      r_d = rows[index + 1]
      row = r_u
  
      if r_d
        r_u_e = !CONTROLS.select { |k, v| r_u.include?( v ) }.empty?
        r_d_e = !CONTROLS.select { |k, v| r_d.include?( v ) }.empty?
        if r_u_e and r_d_e
          row += "".ljust(2) + PYTHON_WORDS[:p] + "\n"
        end
      end
  
      return row
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