require "app_up/hooks/rails_up"

module AppUp
  module Hooks
    class Loader

      def self.load
        [
          Hooks::RailsUp,
        ]
      end
    end
  end
end
