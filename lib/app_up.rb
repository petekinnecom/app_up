require "app_up/version"
require "app_up/path"
require "app_up/hook_runner"
require "app_up/repo"
require "app_up/shell_runner"
require "app_up/config_loader"
require "app_up/config"

module AppUp
  extend ConfigLoader

  user_config config_class: Config, filename: ".app_up"
end
