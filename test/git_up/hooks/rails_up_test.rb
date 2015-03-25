require 'test_helper'

module GitUp
  module Hooks
    class DummyShell
      attr_reader :history

      def initialize
        @history = {
          enqueue: [],
          notify: [],
        }
      end

      def enqueue(*args)
        history[:enqueue] << args
      end

      def notify(*args)
        history[:notify] << args
      end

    end

    class RailsUpTest < Minitest::Test
      
      def setup
        super
        @shell = DummyShell.new
      end

      def test_bundle_directories
        files = [
          'folder/sub_folder/Gemfile.lock',
          'other_folder/other_subfolder/more/Gemfile.lock',
          'unused/Gemfile'
        ]

        hook = RailsUp.new(@shell, files, {})

        hook.run
        assert_equal 2, @shell.history[:enqueue].select {|c| c[0]==:run}.size
        assert @shell.history[:enqueue].include?([:run, RailsUp::BUNDLE_COMMAND, dir: 'folder/sub_folder']), @shell.history
        assert @shell.history[:enqueue].include?([:run, RailsUp::BUNDLE_COMMAND, dir: 'other_folder/other_subfolder/more']), @shell.history
      end

      def test_migrate_directories
        files = [
          'folder/sub_folder/db/migrate/migration.rb',
          'other_folder/other_subfolder/more/db/migrate/migration.rb',
          'unused/db/config.rb',
        ]

        hook = RailsUp.new(@shell, files, {})
        hook.stubs(:migrate).with('test').returns('migrate_test')
        hook.stubs(:migrate).with('development').returns('migrate_development')

        hook.run
        assert_equal 4, @shell.history[:enqueue].select {|c| c[0]==:run}.size
        assert @shell.history[:enqueue].include?([:run, 'migrate_test', dir: 'folder/sub_folder']), @shell.history
        assert @shell.history[:enqueue].include?([:run, 'migrate_development', dir: 'folder/sub_folder']), @shell.history
        assert @shell.history[:enqueue].include?([:run, 'migrate_test', dir: 'other_folder/other_subfolder/more']), @shell.history
        assert @shell.history[:enqueue].include?([:run, 'migrate_development', dir: 'other_folder/other_subfolder/more']), @shell.history
      end

      def test_migrate__drops_db
        no_drop_hook = RailsUp.new('stub', 'stub', {})
        assert_equal nil, no_drop_hook.send(:migrate, 'test').match(/db:drop/)

        no_drop_hook = RailsUp.new('stub', 'stub', {db_reset: true})
        assert no_drop_hook.send(:migrate, 'test').match(/db:drop/)
      end
    end
  end
end
