require "app_up/version"
require "app_up/utils/path"
require "app_up/hooks/runner"
require "app_up/repo"
require "app_up/shell/runner"
require "app_up/configuration/loader"

module AppUp
  extend Configuration::Loader

  user_config filename: ".app_up"
end
