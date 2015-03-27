require "app_up/hook_loader"

module AppUp
  class HookRunner < Struct.new(:shell, :files, :options)

    def run
      hooks = HookLoader.load

      hooks.each do |hook|
        hook.run(shell, files, options)
      end

      shell.flush
    end
  end
end