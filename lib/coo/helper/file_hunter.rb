require 'pathname'

module Coo
  module Helper
    module FileHunter

      # @return 终端工作 dir path
      def self.work_directory_path
        return Dir.pwd
      end

      # @return 终端工作 dir name
      def self.work_directory_name
        return File.basename(Dir.pwd)
      end

      # @param [文件名, 传入 __FILE__] file
      # @return script path
      def self.file_path(file)
        return Pathname.new(file).realpath
      end

      # @param [文件名, 传入 __FILE__] file
      # @return script name
      def self.file_name(file)
        return File.basename(Pathname.new(file).realpath)
      end

      # @param [文件名, 传入 __FILE__] file
      # @return script dir name
      def self.file_directory_name(file)
        return File.dirname(file)
      end

      # 获取文件内容
      # @param [文件名] file_name
      def self.get_file_content(file_name)
        content = ''
        if file_name.to_s.empty?
          puts 'get_file_content file_name is wrong!'
        else
          if File.exist?(file_name) && !File.directory?(file_name)
            target_file = File.new(file_name, 'r')
            if target_file
              content = target_file.read
              target_file.close
            end
          end
        end
        content
      end

      # 根据文件名和内容创建对应文件
      # @param [文件名] file_name
      # @param [文件内容] content
      def self.create_file(file_name, content)
        is_success = false
        if file_name.to_s.empty?
          puts 'file_name is wrong!'
        else
          new_file = File.new(file_name, 'w')
          if new_file
            new_file.syswrite(content)
            new_file.close
            is_success = true
          end
        end
        is_success
      end

    end
  end
end