require 'open3'

module Coo
  module Helper
    module CM

      # 利用 system 语句执行 shell 命令
      def self.sys(command_str)
        puts current_time_str(command_str)
        system command_str
        result = $?
        flag = result.to_s.split(' ').last.to_i
        if flag != 0
          # 非0，执行失败
          puts "error with \"#{command_str}\" !".red
          # exit
        end
        return flag
      end

      def self.sys_commands(*commands)
        all_finish = true
        commands.each_with_index do |command, idx|
          if !command.kind_of? String
            puts "sys_commands 参数错误： #{command}"
            break
          end

          flag = self.sys(command)
          if block_given?
            flag = yield idx, flag
          end
          if flag != 0
            puts 'command break 💥'.red
            all_finish = false
            break
          end
        end
        return all_finish
      end

      # 利用 open3 执行 shell 命令
      def self.open3(command_str, print_command: true, print_command_output: true)
        puts current_time_str(command_str) if print_command

        result = ''
        exit_status = nil

        Open3.popen2e(command_str) do |stdin, stdout_and_stderr, wait_thr|
          stdout_and_stderr.sync = true
          stdout_and_stderr.each do |line|
            puts line.strip if print_command_output
            result << line
          end
          exit_status = wait_thr.value
        end

        if exit_status.exitstatus != 0
          # 非0，执行失败
          puts "error with \"#{command_str}\" !".red
        end

        if block_given?
          yield exit_status.exitstatus, result, command_str
        end
        exit_status.exitstatus
      end

      # private

      private_class_method def self.current_time_str(command_str)
        current_time = Time.new
        current_time.strftime('[%H:%M:%S]: ').blue + command_str.green
      end

    end
  end
end