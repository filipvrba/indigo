require "basic_object"

module Objects
  class Function < FV::BasicObject
    attr_accessor :word, :row, :index_row
  end
end