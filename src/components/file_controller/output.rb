require "basic_object"
require "fileutils"

module Components
  class Output < FV::BasicObject
    def get_relative_path(file_script)
      file_script.path.sub(".#{INDIGO_FILE_TYPE}",
        ".#{PYTHON_FILE_TYPE}")
    end

    def create_files
      @parent.get_file_scripts.each do |file_script|
        f = File.new(get_relative_path(file_script),  "w+")
        f.write(file_script.data.join)
        f.close
      end
    end

    def delete_files
      @parent.get_file_scripts.each do |file_script|
        File.delete get_relative_path(file_script)
      end
    end

    def copy_files(dir)
      begin
        @parent.get_file_scripts.each do |file_script|
          file_path = get_relative_path(file_script)
          abs_file_path = "#{dir}/#{file_path}"

          FileUtils.mkdir_p( File.dirname(abs_file_path) )
          FileUtils.cp(file_path, abs_file_path)
        end

        return true
      rescue
        return false
      end
    end
  end
end