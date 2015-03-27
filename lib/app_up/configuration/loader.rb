require "app_up/configuration/config"

module AppUp
  module Configuration
    module Loader

      def user_config(config_class: Config, filename:)

        self.singleton_class.send(:define_method, :config) do |&config_block|
          config_block.call(config_class)
        end

        home = File.expand_path("~")
        config_file = File.join(home, filename)
        if File.exists?(config_file)
          load config_file
        end
      end
    end
  end
end
