require "app_up/hooks/rails_up"

module AppUp
  class HookLoader

    def self.load
      [
        Hooks::RailsUp,
      ]
    end
  end
end
