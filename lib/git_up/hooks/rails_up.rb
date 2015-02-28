require "git_up/hooks/hook"

module GitUp
  module Hooks
    class RailsUp < Hook
      BUNDLE_COMMAND = "(bundle --local || bundle)"

      def run
        shell.enqueue(:notify, "Running RailsUp")

        files.each do |file|
          if File.basename(file) == "Gemfile.lock"
            add_command(:bundle, dir: File.split(file)[0])
          end

          if file.match(/db\/migrate/)
            add_command(:migrate, dir: file.sub(/\/db\/migrate\/.*/, ''))
          end
        end

        enqueue_commands
      end

      private

      def add_command(command, dir:)
        @commands ||= {}
        @commands[dir] ||= []
        @commands[dir] << command
      end

      # We need to ensure that bundle is run before migrate. 
      # So we group the commands by their root folder, and 
      # bundle first.
      def enqueue_commands
        @commands.each do |dir, commands|
          cmds = []
          if commands.include? :bundle
            cmds << BUNDLE_COMMAND
          end

          if commands.include? :migrate
            ['test', 'development'].each do |env|
              cmds << migrate(env)
            end
          end

          shell.enqueue(:run, cmds.join(' && '), dir: dir)
        end
      end

      def migrate(env)
        "(RAILS_ENV=#{env} bundle exec rake #{options[:db_reset] ? 'db:drop' : ''} db:create 2> /dev/null;\n RAILS_ENV=#{env} bundle exec rake db:migrate)"
      end
    end
  end
end
