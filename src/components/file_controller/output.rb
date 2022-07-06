require "basic_object"

module Components
  class Output < FV::BasicObject
    def get_abs_path(file_script)
      file_script.path.sub(".#{INDIGO_FILE_TYPE}",
        ".#{PYTHON_FILE_TYPE}")
    end

    def create_files
      @parent.get_file_scripts.each do |file_script|
        f = File.new(get_abs_path(file_script),  "w+")
        f.write(file_script.data.join)
        f.close
      end
    end

    def delete_files
      @parent.get_file_scripts.each do |file_script|
        File.delete get_abs_path(file_script)
      end
    end
  end
end