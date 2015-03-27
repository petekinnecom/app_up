require "app_up/hooks/hook"

module AppUp
  module Hooks
    class Hook < Struct.new(:shell, :files, :options)

      def self.run(shell, files, options)
        new(shell, files, options).run
      end

      def run
        raise "Must be implemented"
      end
    end
  end
end
