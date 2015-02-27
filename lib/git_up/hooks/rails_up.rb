module GitUp
  module Hooks
    class RailsUp < Hook
      BUNDLE_COMMAND = "bundle --local || bundle"

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
          if commands.include? :bundle
            shell.enqueue(:run, BUNDLE_COMMAND, dir: dir)
          end

          if commands.include? :migrate
            ['test', 'development'].each do |env|
              shell.enqueue(:run, migrate(env), dir: dir)
            end
          end
        end
      end

      def migrate(env)
        "RAILS_ENV=#{env} bundle exec rake #{options[:db_reset] ? 'db:drop' : ''} db:create 2> /dev/null;\n RAILS_ENV=#{env} bundle exec rake db:migrate"
      end
    end
  end
end
