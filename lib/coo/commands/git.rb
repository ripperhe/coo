
class App
  desc 'Git 命令快捷操作'
  command :git do |c|

    # c.desc '测试'
    # c.command :test do |test|
    #   test.action do |global, options, args|
        # /Users/ripper/Desktop/ZYDebugoxx
        # /Users/ripper/Ripper/Code/Picooc/Picooc
        # Dir.chdir('/Users/ripper/Desktop/ZYDebugoxx') do
        #   puts GitHelper.get_remote_urls_webs_table
        # end

        # s = `git ls-files`.split
        # s.each_with_index do |a, b|
        #   puts "#{a} : #{b}"
        # end

    #   end
    # end

    c.desc 'Git 远程仓库信息 '
    c.command [:webpage, :w] do |webpage|
      webpage.action do |global, options, args|
        puts GitHelper.get_remote_urls_webs_table
      end
    end

    c.desc '快速 push 🚀'
    c.arg_name '<commit info...>', %i(:multiple)
    c.command [:push, :p] do |push|
      push.action do |global_options, options, args|
        commit_info = ''
        args.each_with_index do |arg, idx|
          commit_info.concat(' ') if idx != 0
          commit_info.concat(arg)
        end

        if commit_info.empty?
          commit_info = 'no commit info'
        end

        commands = [
            'git add .',
            "git commit -m \"#{commit_info}\"",
            'git push'
        ]

        all_finish = CM.sys_commands(*commands) do |idx, flag|
          new_flag = flag
          if idx == 2 && flag != 0
            new_flag = CM.sys 'git push --set-upstream origin master'
          end
          new_flag
        end

        if all_finish
          puts GitHelper.get_remote_urls_webs_table
        end

      end
    end

    c.desc '各种快捷删除 🗑'
    c.command [:remove, :rm] do |remove|

      remove.desc '清空所有文件, 并推送到远端 (不删除 commit 记录)❗'
      remove.command [:files, :f] do |files|
        files.action do |global_options, options, args|

          Question.make_sure? 'Are you sure you want to empty the repository?' do |answer|
            if answer
              commands = [
                  "git rm -rf *",
                  "git commit -m 'Empty the repository'",
                  "git push"
              ]

              all_finish = CM.sys_commands(*commands)
              if all_finish
                puts GitHelper.get_remote_urls_webs_table
              end
            end
          end
        end
      end


      remove.desc '删除本地及远端所有 commit 记录 (不删除文件), 慎重操作❗'
      remove.command [:commits, :c] do |commits|
        commits.action do |global_options, options, args|
          Question.make_sure? 'Are you sure you want to remove all commits?' do |answer|
            if answer
              commands = [
                  'git checkout --orphan latest_branch',
                  'git add -A',
                  "git commit -am 'initial'",
                  "git branch -D master",
                  "git branch -m master",
                  "git push -f origin master"
              ]
              all_finish = CM.sys_commands(*commands)
              if all_finish
                puts GitHelper.get_remote_urls_webs_table
              end
            end
          end
        end
      end

    end



  end
end



