require "basic_object"

module Objects
  class Variable < FV::BasicObject
    attr_accessor :word, :row, :index_row
  end
end