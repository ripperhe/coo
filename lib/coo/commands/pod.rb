class App

  desc 'CocoaPods 的快捷操作'
  command :pod do |c|

    c.desc '快速发布 pod 🚀'
    c.command :release do |release|
      release.action do |global, options, args|
        # TODO:
        # 检查是否为 git 仓库
        # 检查是否登录 trunk

        # Spec 文件 及 Project 名字
        specs = Dir["*.podspec"]
        selected_spec = nil
        selected_spec_name = nil
        if specs.count <= 0
          puts '未找到 spec 文件'
          exit
        elsif specs.count == 1
          selected_spec = specs.first
          selected_spec_name = selected_spec[0..-('.podspec'.length + 1)]
          puts "已检索到 Spec 文件: #{selected_spec}".green
        else
          pod_names = specs.map do |spec|
            name = spec[0..-('.podspec'.length + 1)]
          end

          Question.question_and_options("请问需要发布哪个框架？", true, *pod_names) do |idx, value|
            if idx >= 0
              selected_spec = specs[idx]
              selected_spec_name = pod_names[idx]
            else
              selected_spec = specs.first
              selected_spec_name = pod_names.first
            end
            puts "已选中 Spec 文件: #{selected_spec}".green
          end
        end

        # version
        podspec_file = PodspecHelper.new(selected_spec, true)
        current_spec_version = podspec_file.version_value

        reg = RegexpCollection.n_a_u_h_1_n
        version_comp = current_spec_version.to_s.split(/\./)
        if version_comp.count == 3
          reg = RegexpCollection.n_a_u_h_0_n
        end

        version = nil
        Question.remind_input("当前 spec 中的 version 为 #{current_spec_version}, 请输入框架即将发布的 version: ", RegexpCollection.n_a_u_h_p_0_n) do |value|
          if value.to_s.empty?
            version = podspec_file.bump_version('patch')
          else
            version = value
          end
          puts "已设置即将发布的版本号: #{version}".green
        end


        # pod repo
        pod_repos_list = `pod repo list`
        list_components = pod_repos_list.to_s.split(/\n/)
        list_components_last = list_components.last.to_s.split
        pod_repo_count = list_components_last.first.to_i
        if list_components_last.count != 2 || !list_components_last.last.to_s.include?('repo') || pod_repo_count <= 0
          puts '未找到 CocoaPods Spec 仓库'
          exit
        end

        pod_repo_names = Array.new
        for i in 0..(pod_repo_count - 1)
          name = list_components[i * 5 + 1]
          pod_repo_names.push name
        end

        is_master = true
        selected_repo = 'master'
        unless pod_repo_names.count == 1 && pod_repo_names.first.to_s.eql?('master')
          # 除非只有官方库，不然要选 spec 库
          Question.question_and_options("请问需要发布到哪个 Spec 仓库？", true, *pod_repo_names) do |idx, name|
            if idx > 0
              is_master = false
              selected_repo = name
            end
            puts "已选中 pod repo: #{selected_repo}".green
          end
        end

        # fastlane fastfile
        fast_dir_name = 'fastlane'
        fast_file_name = 'Fastfile'
        fastlane_file = fast_dir_name + '/' + fast_file_name

        fastlane_file_content = FileHunter.get_file_content(fastlane_file)
        fastlane_source = "import_from_git(url: 'https://github.com/ripperhe/fastlane-files', branch: 'master')"

        if File.exist?(fast_dir_name)
          # 存在名为 fastlane 的文件
          unless File.directory?(fast_dir_name)
            puts "请将根目录的中名为 #{fast_dir_name} 的文件删除, 或者重命名, 然后重新操作!".red
            exit
          end
        else
          Dir.mkdir(fast_dir_name)
        end

        if File.exist?(fastlane_file)
            if File.directory?(fastlane_file)
            puts "请将 #{fast_dir_name} 的文件夹删除, 或者重命名, 然后重新操作!".red
            exit
          end
          unless fastlane_file_content.include?(fastlane_source)
            fastlane_file_content = fastlane_source + '\n' + fastlane_file_content
            FileHunter.create_file(fastlane_file, fastlane_file_content)
            puts "已更新 #{fastlane_file} 文件".green
          end
        else
          FileHunter.create_file(fastlane_file, fastlane_source)
          puts "已创建 #{fastlane_file} 文件".green
        end

        # 确认发布
        Question.easy_make_sure?("确认发布框架 #{selected_spec_name} 的 #{version} 版本到 #{is_master ? 'CocoaPods/Specs' : selected_repo } 吗？") do |value|
          if value

            if is_master
              CM.sys("fastlane release_pod project:#{selected_spec_name} version:#{version}")
            else
              CM.sys("fastlane release_pod repo:#{selected_repo} project:#{selected_spec_name} version:#{version}")
            end

          end
        end

      end
    end
  end
end