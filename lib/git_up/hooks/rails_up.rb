require "git_up/hooks/hook"

module GitUp
  module Hooks
    class RailsUp < Hook
      BUNDLE_COMMAND = "bundle --local || bundle"

      def run
        shell.notify( "Running RailsUp\n----------")

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

      def add_command(action, dir:)
        @commands ||= {}
        @commands[dir] ||= []
        @commands[dir] << action unless @commands[dir].include? action
      end

      # We need to ensure that bundle is run before migrate. 
      # So we group the commands by their root folder, and 
      # bundle first.
      def enqueue_commands
        command_count = @commands.values.flatten.size.to_s

        i = 1
        @commands.each do |dir, actions|
          migrate_block = Proc.new {
            ['test', 'development'].each do |env|
              shell.enqueue(:run, migrate(env), dir: dir)
            end
          }

          actions.each do |command|
            shell.enqueue(:notify, "#{i.to_s.rjust(command_count.length)}/#{command_count.to_s} #{command.to_s.ljust(7)} : #{dir}")
            i+=1
          end

          if [:bundle, :migrate].all? { |c| actions.include?(c) }
            shell.enqueue(:run, BUNDLE_COMMAND, dir: dir, &migrate_block)
          elsif actions.include? :bundle
            shell.enqueue(:run, BUNDLE_COMMAND, dir: dir)
          elsif actions.include? :migrate
            migrate_block.call
          end
        end
      end

      def migrate(env)
        "RAILS_ENV=#{env} bundle exec rake #{options[:db_reset] ? 'db:drop' : ''} db:create 2> /dev/null;\n RAILS_ENV=#{env} bundle exec rake db:migrate"
      end
    end
  end
end
