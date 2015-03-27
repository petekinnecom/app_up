require "app_up/hooks/loader"

module AppUp
  module Hooks
    class Runner < Struct.new(:shell, :files, :options)

      def run
        hooks = Hooks::Loader.load

        hooks.each do |hook|
          hook.run(shell, files, options)
        end

        shell.flush
      end
    end
  end
end
