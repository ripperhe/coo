module Coo
  module Helper
    module Question
      # @param [确认提示] remind_str
      # @return [状态值 turn 为继续执行；false 为取消执行]
      def self.make_sure?(remind_str = 'Are you sure you want to do this?')
        answer = self.question_and_options(remind_str, false, 'yes', 'no')
        flag = false
        if answer == 0
          puts 'Continue 🚀'.green
          flag = true
        else
          puts 'Cancel 💥'.red
        end
        if block_given?
          yield flag
        end
        flag
      end

      def self.easy_make_sure?(remind_str = 'Are you sure you want to do this?')
        answer = self.question_and_options(remind_str, true, 'yes', 'no')
        flag = false
        if answer == 0 || answer == -1
          puts 'Continue 🚀'.green
          flag = true
        else
          puts 'Cancel 💥'.red
        end
        if block_given?
          yield flag
        end
        flag
      end

      # @param [问题] question_str
      # @param [是否允许直接点 enter 键] accept_enter
      # @param [多个选项] options
      # @return [选中的值, -1 为直接 enter; 其他值为选中值得下标]
      def self.question_and_options(question_str, accept_enter, *options, &block)
        if (question_str.to_s.empty? || options.length == 0)
          puts 'question_and_options 参数错误'
          exit
        end

        option_str = '[ '
        for i in 0...options.length
          op = options[i].to_s
          if op.empty?
            puts 'question_and_options 参数错误'
            exit
          end
          option_str = option_str.concat(op)
          if i < options.length - 1
            option_str = option_str.concat(' / ')
          end
        end
        option_str = option_str.concat(' ]')

        show_str = question_str + ' ' + option_str
        puts show_str.blue

        answer = $stdin.gets.chomp.downcase
        selected = -2

        if answer.to_s.empty?
          selected = -1
        else
          options.each_with_index do |opi, ii|
            if answer == opi.to_s.downcase
              selected = ii
              break
            end
          end
        end

        lower_limit = 0
        if accept_enter == true
          lower_limit = -1
        end

        if selected < lower_limit
          if block_given?
            return self.question_and_options("💥 Input error, please input again!", accept_enter, *options, &block)
          else
            return self.question_and_options("💥 Input error, please input again!", accept_enter, *options)
          end

        else
          if block_given?
            value = ''
            if selected >= 0
              value = options[selected].to_s
            end
            yield selected, value
          end
          return selected
        end
      end

      def self.remind_input(question_str, valid_regexp = /[\s\S]*/, &block)
        puts question_str.blue
        answer = $stdin.gets.chomp
        if valid_regexp.match(answer)
          if block_given?
            yield answer
          end
          return answer
        else
          return remind_input("💥 Input error, please input again!", valid_regexp, &block)
        end
      end

    end
  end
end
