require 'singleton'

module Indigo
  class DB
    include Singleton
    attr_reader :root

    def initialize
      @root = JsonParser.new abs_path("share/root.json")
    end

    private
    def abs_path rel_path
      File.absolute_path("#{ROOT_PATH_DB}/#{rel_path}", __FILE__)
    end
  end
end