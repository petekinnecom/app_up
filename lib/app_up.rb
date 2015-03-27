require "app_up/version"
require "app_up/path"
require "app_up/hook_runner"
require "app_up/repo"
require "app_up/shell_runner"
require "app_up/config_loader"
require "app_up/config"

module AppUp
#  include ConfigLoader

#  config config_class: Config, filename: ".app_up"

  def self.config
    yield Config
  end

  ConfigLoader.new(self, Config, ".app_up").run
end
