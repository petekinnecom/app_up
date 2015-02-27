require_relative './hooks/hook'
require_relative './hooks/rails_up'

module GitUp
  class HookLoader

    def self.load
      [
        Hooks::RailsUp,
      ]
    end
  end
end
