module Coo
  module Helper
    module GitHelper

      def self.parse_ssh(ssh_str)
        if !ssh_str.to_s.start_with?('git@')
          puts 'parse_ssh 参数错误'
          return nil
        end

        center_str = ssh_str[('git@'.length)..-('.git'.length + 1)]

        components = center_str.to_s.split(':',)
        if components.length == 2
          last = components.last.to_s
          sub_com = last.split('/')
          if sub_com.length == 2
            return {'author' => sub_com[0], 'repo' => sub_com[1]}
          end
        end

        return nil
      end

      def self.parse_https(https_str)
        if !https_str.to_s.start_with?('https://')
          puts 'parse_https 参数错误'
          return nil
        end

        center_str = https_str[('https://'.length)..-('.git'.length + 1)]

        components = center_str.to_s.split('/')
        if components.length == 3
          return {'author' => components[1], 'repo' => components[2]}
        end

        return nil
      end

      def self.parse_url_get_web(str)
        result = nil
        if str.start_with?('https://')
          result = self.parse_https(str)
        elsif str.start_with?('git@')
          result = self.parse_ssh(str)
        end

        if result.length != 2
          return nil
        end

        author = result['author']
        repo = result['repo']

        web_url = ''
        if str.include?('github.com')
          # github
          web_url = 'https://github.com/'.concat(author).concat('/').concat(repo)
        elsif str.include?('coding.net')
          # coding
          web_url = 'https://coding.net/u/'.concat(author).concat('/p/').concat(repo).concat('/git')
        elsif str.include?('picooc.com')
          # gitlab picooc
          web_url = 'https://git.picooc.com/'.concat(author).concat('/').concat(repo)
        end

        return web_url
      end

      def self.get_remotes
        remote_info = `git remote`.to_s.chomp
        if remote_info.empty?
          return nil
        end
        remote_info.split(/\n/)
      end

      # {'orgin':[{url => "xxx", web => "www"}, {}...], 'up...':[{}, {}...]}
      def self.get_remote_urls_webs
        remotes = self.get_remotes
        if !remotes
          return nil
        end

        urls_webs_hash = Hash.new
        remotes.each do |remote|
          url_info = `git remote get-url --all #{remote}`.to_s.chomp
          if url_info.empty?
            next
          end
          urls = url_info.split(/\n/)

          one_remote = Array.new

          urls.each do |url|
            web = self.parse_url_get_web(url)
            sub_hash = Hash.new
            sub_hash["url"] = url
            sub_hash["web"] = web
            one_remote << sub_hash
          end

          urls_webs_hash[remote] = one_remote
        end

        urls_webs_hash
      end

      def self.get_remote_urls_webs_table
        urls_webs_hash = get_remote_urls_webs
        if !urls_webs_hash
          return nil
        end

        table = Terminal::Table.new do |t|
          # t.title = 'Remotes'
          t.headings = [{:value => 'remote', :alignment => :center}, {:value => 'url', :alignment => :center}, {:value => 'webpage', :alignment => :center}]

          first = true
          urls_webs_hash.each_pair do |key , value|
            if first
              first = false
            else
              t.add_separator
            end
            value.each do |sub|
              t.add_row [key ,sub['url'], sub['web']]
            end
          end
        end
        return table
      end

    end

  end
end
