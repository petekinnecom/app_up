require "git_up/hooks/rails_up"

module GitUp
  class HookLoader

    def self.load
      [
        Hooks::RailsUp,
      ]
    end
  end
end
